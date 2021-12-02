//
//  NotificationViewController.swift
//  TIKTOK CLONE
//
//  Created by Ankit Singh on 30/10/21.
//
import UIKit

class NotificationViewController: UIViewController {
    //MARK: - Properties
    private let noNotificationLabel : UILabel = {
        let lable = UILabel()
        lable.textColor = .secondaryLabel
        lable.text = "No Notifications"
        lable.textAlignment = .center
        lable.isHidden = true
        return lable
    }()
    
    private let spinner : UIActivityIndicatorView = {
        let spinnner = UIActivityIndicatorView(style: .large)
        spinnner.tintColor = .label
        spinnner.startAnimating()
        return spinnner
    }()
    
    
    
    
    private let tableView : UITableView = {
        let table = UITableView()
        table.register(Notifications_PostLikedTableCell.self,
                       forCellReuseIdentifier: Notifications_PostLikedTableCell.id)
        table.register(Notifications_PostCommentTableCell.self,
                       forCellReuseIdentifier: Notifications_PostCommentTableCell.id)
        table.register(Notifications_UserFollowedTableCell.self,
                       forCellReuseIdentifier: Notifications_UserFollowedTableCell.id)
        table.register(UITableViewCell.self,
                       forCellReuseIdentifier: "cell")
        table.isHidden = true
        return table
    }()
    
    private let refreshControl : UIRefreshControl = {
       let control = UIRefreshControl()
        return control
    }()
    
    private var notifications : [Notification] = []
    
    //MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        view.addSubview(noNotificationLabel)
        view.addSubview(spinner)
        // Do any additional setup after loading the view.
        refreshControl.addTarget(self, action: #selector(didPullToRefresh(_:)), for: .valueChanged)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = refreshControl
        fetchNotifications()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        noNotificationLabel.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        noNotificationLabel.center = view.center
        spinner.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        spinner.center = view.center
    }
    
    //MARK: - Methods
    func fetchNotifications(){
        DatabaseManager.shared.getNotifications { [weak self] notifications in
            DispatchQueue.main.async {
                self?.spinner.stopAnimating()
                self?.spinner.isHidden = true
                self?.notifications = notifications
                self?.updateUI()
            }
            
        }
        
    }
    
    func updateUI(){
        if notifications.isEmpty {
            noNotificationLabel.isHidden = false
            tableView.isHidden = true
        }
        else {
            noNotificationLabel.isHidden = true
            tableView.isHidden = false
        }
        tableView.reloadData()
    }
    
    @objc func didPullToRefresh(_ sender:UIRefreshControl){
        sender.beginRefreshing()
        
        DatabaseManager.shared.getNotifications { [weak self] notifications in
            
            DispatchQueue.main.asyncAfter(deadline: .now()+3) {
                self?.notifications = notifications
                self?.tableView.reloadData()
                sender.endRefreshing()
            }
            

        }
        
        
    }
    
}
extension NotificationViewController : UITableViewDelegate,UITableViewDataSource{
    
    //status to allow table to edit a particular cell via user
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //what type of operation user can perform
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    //what to do if user is performing that operation the cell (swipe to delete)
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //if action is not delete then we return early
        guard editingStyle == .delete else {
            return
        }
        var model = notifications[indexPath.row]
        model.isHidden = true
        DatabaseManager.shared.markNotificationAsHidden(notificationID: model.identifier) { [weak self] isCompleted in
            
            DispatchQueue.main.async {
                if isCompleted {
                    //update our notification array to remove those values who have their ishidden property set via cell delete action from user
                    self?.notifications = self?.notifications.filter({ notification in
                        notification.isHidden == false
                    }) ?? []

                    tableView.beginUpdates()
                    tableView.deleteRows(at: [indexPath], with: .none)
                    tableView.endUpdates()
                }
            }

        }
        //tableView.reloadData()
        
        //delete with animation

    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let notificationModel = notifications[indexPath.row]
        
        switch notificationModel.type{
            
        case .postLike(let postName):
            
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: Notifications_PostLikedTableCell.id,
                for: indexPath) as? Notifications_PostLikedTableCell  else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath)
                    return cell
                }
            cell.delegate = self
            cell.configureWith(with: postName,model: notificationModel)
            return cell
            
        
        
        case .userFollow(let username):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: Notifications_UserFollowedTableCell.id,
                for: indexPath) as? Notifications_UserFollowedTableCell  else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath)
                    return cell
                }
            cell.delegate = self
            cell.configureWith(with: username, model: notificationModel)
            return cell
            
            
            
        case .postComment(let postName):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: Notifications_PostCommentTableCell.id,
                for: indexPath) as? Notifications_PostCommentTableCell  else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath)
                    return cell
                }
            cell.delegate = self
            cell.configureWith(with: postName, model: notificationModel)
            return cell
        }
        
    }
    
    
}

extension NotificationViewController : UserFollowedCellDelegate {
    func notifications_UserFollowedTableCell(_ cell: Notifications_UserFollowedTableCell, didTapAvatarFor username: String) {
        let vc = ProfileViewController(user: User(username: username, profilePictureURL: nil, identifier: "123"))
        vc.title = username.uppercased()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func notifications_UserFollowedTableCell(_ cell: Notifications_UserFollowedTableCell, didTapFollowFor username: String) {
        DatabaseManager.shared.follow(username: username) { success in
            if !success {
                print("something went wrong while following")
            }
        }
    }
    
    
}
extension NotificationViewController : PostCommentCellDelegate{
    func tappedOnPostCommentThumbnail(_ cell: Notifications_PostCommentTableCell, didTapPostwith identifier: String) {
        openPost(with: identifier)
    }
    
    
}

extension NotificationViewController : PostLikedCellDelegate{
    func postLiked(_ cell: Notifications_PostLikedTableCell, didTapPostwith identifier: String) {
        openPost(with: identifier)
    }
    
    
}

extension NotificationViewController {
    func openPost(with identifier : String){
        //resolve model model from database for that id
        let user = User(username: "Ankit",
                        profilePictureURL: nil,
                        identifier: UUID().uuidString)
        let vc = PostViewController(model: PostModel(identifier: identifier,user:user))
        vc.title = "Video"
        navigationController?.pushViewController(vc, animated: true)
    }
}
