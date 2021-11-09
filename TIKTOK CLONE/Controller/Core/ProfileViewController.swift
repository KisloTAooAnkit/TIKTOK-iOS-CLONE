//
//  ProfileViewController.swift
//  TIKTOK CLONE
//
//  Created by Ankit Singh on 30/10/21.
//

import UIKit

class ProfileViewController: UIViewController {
    
    let user : User
    
    init(user:User){
        self.user  = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = user.username.uppercased()
        // Do any additional setup after loading the view.
    }
    
}
