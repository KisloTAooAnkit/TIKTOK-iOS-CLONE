//
//  UserListViewController.swift
//  TIKTOK CLONE
//
//  Created by Ankit Singh on 30/10/21.
//

import UIKit

class UserListViewController: UIViewController {

    
    private let tableView : UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private let noUsersLabel : UILabel = {
        let label = UILabel()
        label.text = "No Users"
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        return label
    }()
    
    enum ListType : String {
        case followers
        case following
    }
    
    public var users : [String] = []
    
    let user : User
    let type : ListType
    
    init(type : ListType,user :User) {
        self.type = type
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        
        if users.isEmpty
        {
            view.addSubview(noUsersLabel)
            noUsersLabel.sizeToFit()
        }
        else {
            switch type {
            case .followers:
                title = "Followers"
            case .following:
                title = "Following"

        }
        
        
        
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        if tableView.superview  == view {
            tableView.frame = view.bounds
        }
        else {
            noUsersLabel.center = view.center
        }
    }
}

extension UserListViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.text = users[indexPath.row]
        return cell
    }
    
    
    
}
