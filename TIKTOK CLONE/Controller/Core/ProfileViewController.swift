//
//  ProfileViewController.swift
//  TIKTOK CLONE
//
//  Created by Ankit Singh on 30/10/21.
//

import UIKit
import ProgressHUD

class ProfileViewController: UIViewController {
    
    var user : User
    
    
    enum PicturePickerType{
        case camera
        case photoLibrary
    }
    
    var isCurrentUserProfile : Bool {
        return user.username == UserDefaults.standard.string(forKey: "username")
    }
    
    private let collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .systemBackground
        collection.showsVerticalScrollIndicator = false
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collection.register(ProfileCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ProfileCollectionReusableView.identifier)
        return collection
    }()
    
    
    private var posts = [PostModel]()
    
    //MARK: - Init
    init(user:User){
        self.user  = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = user.username.uppercased()
        // Do any additional setup after loading the view.
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        
        let userName = UserDefaults.standard.string(forKey: "username") ?? "Me"
        
        if title == userName{
            let barButton = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .done, target: self, action: #selector(didTapSettings))
            navigationItem.rightBarButtonItem = barButton
        }
        
        fetchPosts()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    
    @objc func didTapSettings() {
        let vc = SettingsViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func fetchPosts() {
        DatabaseManager.shared.getPosts(for: user) { [weak self] postModels in
            DispatchQueue.main.async {
                self?.posts = postModels
                self?.collectionView.reloadData()
            }
        }
    }
}

extension ProfileViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    //MARK: -  datasource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let postModel = posts[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .systemBlue
        return cell
    }
    
    //MARK: - delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    //MARK: - layout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.width - 12)/3
        return CGSize(width: width, height: width * 1.6) //1.8 means 16:9 ratio
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    //MARK: - header of collection
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              
                let header = collectionView.dequeueReusableSupplementaryView(
                    ofKind: UICollectionView.elementKindSectionHeader,
                    withReuseIdentifier: ProfileCollectionReusableView.identifier,
                    for: indexPath) as? ProfileCollectionReusableView
                
        else {
            return UICollectionReusableView()
        }
        header.delegate = self
        
        
        let viewModel  = ProfileHeaderViewModel(avatarImageURL: user.profilePictureURL,
                                                followerCount: 120,
                                                followingCount: 200,
                                                isFollowing: isCurrentUserProfile ? nil : false)
        header.configure(with: viewModel)
        
        
        
        
        
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.width, height: 300)
    }
}

extension ProfileViewController : ProfileCollectionReusableViewDelegate {
    
    func profileCollectionReusableView(_ header: ProfileCollectionReusableView,
                                       didTapPrimaryButtonWith viewModel: ProfileHeaderViewModel) {
        
        guard let currentUsername = UserDefaults.standard.string(forKey: "username") else {
            return
        }
        if self.user.username == currentUsername {
            //EDIT PROFILE OPEN
        }
        else {
            //FOllow or unfollow current user profile
        }
    }
    
    func profileCollectionReusableView(_ header: ProfileCollectionReusableView,
                                       didTapFollowersButtonWith viewModel: ProfileHeaderViewModel) {
        
    }
    
    func profileCollectionReusableView(_ header: ProfileCollectionReusableView,
                                       didTapFollowingButtonWith viewModel: ProfileHeaderViewModel) {
        
    }
    
    func profileCollectionReusableView(_ header: ProfileCollectionReusableView, didTapAvatarFor viewModel: ProfileHeaderViewModel) {
        guard isCurrentUserProfile else {
            return
        }
        let actionSheet = UIAlertController(title: "Profile  Picture", message: "Select Image", preferredStyle: .actionSheet)
        actionSheet.addAction(
            UIAlertAction(title: "Cancel", style: .cancel))
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default,handler: { action in
            DispatchQueue.main.async {
                self.presentProfilePicturePicker(type: .camera)
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo library", style: .default,handler: { action in
            DispatchQueue.main.async {
                self.presentProfilePicturePicker(type: .photoLibrary)
            }
        }))
        present(actionSheet, animated: true, completion: nil)
    }
    
    
    func presentProfilePicturePicker(type : PicturePickerType){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = type == .camera ? .camera : .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
}

extension ProfileViewController : UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        ProgressHUD.show("Uploading")
        StorageManager.shared.uploadProfilePicture(with: image) { [weak self] result in
            DispatchQueue.main.async {
                
                guard let strongSelf = self else {
                    return
                }
                
                switch result {
                case .success(let downloadURL):
                    UserDefaults.standard.setValue(downloadURL.absoluteString, forKey: "profile_picture_url")
                    strongSelf.user = User(username: strongSelf.user.username,
                                           profilePictureURL: downloadURL,
                                           identifier: strongSelf.user.username)
                    ProgressHUD.showSuccess("Updated!")
                    strongSelf.collectionView.reloadData()
                    break
                case .failure(let error):
                    ProgressHUD.showError("Failed to update profile picture")
                    break
                }
            }

        }
        
        //upload and update ui
    }
}
