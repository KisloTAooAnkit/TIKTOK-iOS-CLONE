//
//  CaptionViewController.swift
//  TIKTOK CLONE
//
//  Created by Ankit Singh on 23/11/21.
//

import UIKit
import ProgressHUD

class CaptionViewController: UIViewController {
    
    private let captionTextView : UITextView = {
       let textView = UITextView()
        textView.contentInset = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        textView.backgroundColor = .secondarySystemBackground
        textView.layer.cornerRadius = 8
        textView.layer.masksToBounds = true
        return textView
        
        
    }()
    
    let videoURL : URL
    
    //MARK: - Init
    init(videoURL : URL){
        self.videoURL = videoURL
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Add Caption"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Post", style: .done, target: self, action: #selector(didTapPost))
        view.addSubview(captionTextView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        captionTextView.frame = CGRect(x: 5, y: 5, width: view
                                        .width-10, height: 150)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        captionTextView.becomeFirstResponder()
    }
    
    @objc private func didTapPost(){
        captionTextView.resignFirstResponder()
        let caption = captionTextView.text ?? ""
        ProgressHUD.show("Uploading Video")
        // Generate a video name that is unique based on id
        let newVideoName = StorageManager.shared.generateVideoName()
        //upload video
        StorageManager.shared.uploadVideo(from: videoURL, fileName: newVideoName) { [weak self] isUploaded in
            DispatchQueue.main.async { [weak self] in
                if isUploaded {
                    //update database
                    DatabaseManager.shared.insertPostName(filename: newVideoName,caption : caption) { nameInsertionSuccesful in
                        if nameInsertionSuccesful {
                            ProgressHUD.dismiss()
                            HapticsManager.shared.vibrate(for: .success)
                            //reset camera and switch to feed
                            self?.navigationController?.popToRootViewController(animated: true)
                            self?.tabBarController?.selectedIndex = 0
                            self?.tabBarController?.tabBar.isHidden = false
                        }
                        else {
                            self?.showAlert(title: "Whoops", message: "we were unable to upload video")
                        }
                    }
                    
                } else {
//                    let alert = UIAlertController(title: "Whoops", message: "we were unable to upload video", preferredStyle: .alert)
//                    alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
//                    self?.present(alert, animated: true, completion: nil)
                    self?.showAlert(title: "Whoops", message: "we were unable to upload video")
                }
            }

        }

    }
    
    private func showAlert(title : String , message : String){
        ProgressHUD.dismiss()
        HapticsManager.shared.vibrate(for: .error)
        let alert = UIAlertController(title: title  , message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
