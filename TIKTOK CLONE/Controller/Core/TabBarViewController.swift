//
//  TabBarViewController.swift
//  TIKTOK CLONE
//
//  Created by Ankit Singh on 30/10/21.
//

import UIKit

class TabBarViewController: UITabBarController {

    private var isSignInPresented = false
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setupControllers()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !isSignInPresented{
            presentSignInIfNeeded()
        }
        
    }
    
    private func presentSignInIfNeeded(){
        if !AuthManager.shared.isSignedIn{
            isSignInPresented = true
            let vc = SignInViewController()
            vc.completion = { [weak self ] in
                self?.isSignInPresented = false
            }
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            present(navVC, animated: true, completion: nil)
        }
    }
    
    private func setupControllers(){
        let home = HomeViewController()
        let explore = ExploreViewController()
        let camera = CameraViewController()
        let notifications = NotificationViewController()
        var url : URL?
        let user = UserDefaults.standard.string(forKey: "username") ?? "Me"
        if let dpUrl = UserDefaults.standard.string(forKey: "profile_picture_url") {
            url = URL(string: dpUrl)
        }
        let profile = ProfileViewController(user: User(username: user,
                                                       profilePictureURL: url,
                                                       identifier: user))
        

        notifications.title = "Notifications"
        profile.title = "Profile"
        
        

        let nav1 = UINavigationController(rootViewController: home)
        let nav2 = UINavigationController(rootViewController: explore)
        let nav3 = UINavigationController(rootViewController: notifications)
        let nav4 = UINavigationController(rootViewController: profile)
        let cameraNav = UINavigationController(rootViewController: camera)
        //cameraNav.navigationBar.isHidden = true
        
        nav1.navigationBar.backgroundColor = .clear
        nav1.navigationBar.setBackgroundImage(UIImage(), for: .default)
        nav1.navigationBar.shadowImage = UIImage()
        
        cameraNav.navigationBar.backgroundColor = .clear
        cameraNav.navigationBar.setBackgroundImage(UIImage(), for: .default)
        cameraNav.navigationBar.shadowImage = UIImage()
        cameraNav.navigationBar.tintColor = .white
        
        nav1.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "house"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "safari"), tag: 2)
        camera.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "camera"), tag: 3)
        nav3.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "bell"), tag: 4)
        nav4.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "person.circle"), tag: 5)
        nav4.navigationBar.tintColor = .label



        
        
        setViewControllers([nav1,nav2,cameraNav,nav3,nav4], animated: true)
    }


}
