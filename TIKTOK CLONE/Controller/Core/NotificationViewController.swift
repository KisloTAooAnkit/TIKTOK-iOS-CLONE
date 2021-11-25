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
    
    private var notifications : [Notification] = []
    
    //MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        view.addSubview(noNotificationLabel)
        view.addSubview(spinner)
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
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
    
}
extension NotificationViewController : UITableViewDelegate,UITableViewDataSource{
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
            
            cell.configureWith(with: postName)
            return cell
            
        
        
        case .userFollow(let username):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: Notifications_UserFollowedTableCell.id,
                for: indexPath) as? Notifications_UserFollowedTableCell  else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath)
                    return cell
                }
            
            cell.configureWith(with: username)
            return cell
            
            
            
        case .postComment(let postName):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: Notifications_PostCommentTableCell.id,
                for: indexPath) as? Notifications_PostCommentTableCell  else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath)
                    return cell
                }
            
            cell.configureWith(with: postName)
            return cell
        }
        
    }
    
    
}
