//
//  UserListViewController.swift
//  TIKTOK CLONE
//
//  Created by Ankit Singh on 30/10/21.
//

import UIKit

class UserListViewController: UIViewController {

    
    let tableView : UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    
    enum ListType {
        case followers
        case following
    }
    
    
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
        switch type {
        case .followers:
            title = "Followers"
        case .following:
            title = "Following"
        
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
}

extension UserListViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath)
        cell.textLabel?.text = "Hello"
        return cell
    }
    
    
    
}
