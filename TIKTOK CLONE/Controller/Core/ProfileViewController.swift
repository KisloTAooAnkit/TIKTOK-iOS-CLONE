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
        collection.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: PostCollectionViewCell.identifier)
        collection.register(ProfileCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ProfileCollectionReusableView.identifier)
        return collection
    }()
    
    private var followers = [String]()
    private var following = [String]()
    private var isFollower : Bool = false
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
        
        if title == userName.uppercased(){
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCollectionViewCell.identifier, for: indexPath) as? PostCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: postModel)
        return cell
    }
    
    //MARK: - delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let post = posts[indexPath.row]
        let vc = PostViewController(model: post)
        vc.delegate = self
        vc.title = "Video"
        navigationController?.pushViewController(vc, animated: true)
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
        let group = DispatchGroup()
        group.enter()
        group.enter()
        group.enter()
        
        DatabaseManager.shared.getRelationships(for: user, type: .followers) { [weak self] followers in
            defer {
                group.leave()
            }
            self?.followers = followers
        }
        
        DatabaseManager.shared.getRelationships(for: user, type: .following) { [weak self] following in
            defer {
                group.leave()
            }
            
            self?.following = following
        }
        
        DatabaseManager.shared.isValidRelationship(for: user,
                                                      type: .followers) { [weak self] isFollower in
            defer {
                group.leave()
            }
            
            self?.isFollower = isFollower
        }
        
        
        group.notify(queue: .main) {
            let viewModel  = ProfileHeaderViewModel(avatarImageURL: self.user.profilePictureURL,
                                                    followerCount: self.followers.count,
                                                    followingCount: self.following.count,
                                                    isFollowing: self.isCurrentUserProfile ? nil : self.isFollower)
            header.configure(with: viewModel)
        }
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
            let vc = EditProfileViewController()
            let navVC = UINavigationController(rootViewController: vc)
            present(navVC, animated: true, completion: nil)
            //navigationController?.pushViewController(vc, animated: true)
        }
        else {
            //FOllow or unfollow current user profile
            if self.isFollower {
                //unfollow
                DatabaseManager.shared.updateRelationship(for: user, follow: !self.isFollower) { [weak self] success in
                    if success {
                        DispatchQueue.main.async {
                            self?.isFollower = false
                            self?.collectionView.reloadData()
                        }
                    }
                    
                    else {
                        //show alert
                    }
                    
                }
            }
            else {
                //follow
                DatabaseManager.shared.updateRelationship(for: user, follow: !self.isFollower) { [weak self] success in
                    if success {
                        DispatchQueue.main.async {
                            self?.isFollower = true
                            self?.collectionView.reloadData()
                        }
                    }
                    
                    else {
                        //show alert
                    }
                    
                }
            }
        }
    }
    
    func profileCollectionReusableView(_ header: ProfileCollectionReusableView,
                                       didTapFollowersButtonWith viewModel: ProfileHeaderViewModel) {
        let vc = UserListViewController(type: .followers, user: user)
        vc.users = self.followers
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func profileCollectionReusableView(_ header: ProfileCollectionReusableView,
                                       didTapFollowingButtonWith viewModel: ProfileHeaderViewModel) {
        let vc = UserListViewController(type: .following, user: user)
        vc.users = self.following
        navigationController?.pushViewController(vc, animated: true)
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

extension ProfileViewController : PostViewControllerDelegate {
    func postViewController(_ vc: PostViewController, didTapCommentButtonFor post: PostModel) {
        //
    }
    
    func postViewController(_ vc: PostViewController, didTapProfileButton post: PostModel) {
        //
    }
    
    
}
