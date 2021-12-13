//
//  EditProfileViewController.swift
//  TIKTOK CLONE
//
//  Created by Ankit Singh on 10/12/21.
//

import UIKit

class EditProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Edit Profile"
        view.backgroundColor = .systemBackground
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close,
                                                           target: self,
                                                           action: #selector(didTapClose))
        // Do any additional setup after loading the view.
    }
    
    @objc func didTapClose() {
        dismiss(animated: true) {
            //
        }
    }
}
