//
//  ProfileCollectionReusableView.swift
//  TIKTOK CLONE
//
//  Created by Ankit Singh on 30/11/21.
//

import UIKit
import SDWebImage

protocol ProfileCollectionReusableViewDelegate : AnyObject {
    
    func profileCollectionReusableView(_ header : ProfileCollectionReusableView,
                                       didTapPrimaryButtonWith viewModel:ProfileHeaderViewModel)
    
    func profileCollectionReusableView(_ header : ProfileCollectionReusableView,
                                       didTapFollowersButtonWith viewModel:ProfileHeaderViewModel)
    
    func profileCollectionReusableView(_ header : ProfileCollectionReusableView,
                                       didTapFollowingButtonWith viewModel:ProfileHeaderViewModel)
    
    func profileCollectionReusableView(_ header : ProfileCollectionReusableView,
                                       didTapAvatarFor viewModel:ProfileHeaderViewModel)
    
}



class ProfileCollectionReusableView: UICollectionReusableView {
        
    static let identifier = "ProfileCollectionReusableView"
    
    weak var delegate : ProfileCollectionReusableViewDelegate?
    
    var viewModel : ProfileHeaderViewModel?
    
    private let avatarImageView : UIImageView = {
       let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .secondarySystemBackground
        return imageView
    }()

    //Follow or edit profile (depends on viewing yourself or other profile)
    private let primaryButton : UIButton = {
       let button = UIButton()
        
        button.layer.cornerRadius = 6
        button.layer.masksToBounds = true
        button.setTitle("Follow", for: .normal)
        button.backgroundColor = .systemPink
        button.titleLabel?.font = .systemFont(ofSize: 20)
        return button
    }()
    
    private let followersButton : UIButton = {
        let button = UIButton()
         button.layer.cornerRadius = 6
         button.layer.masksToBounds = true
        button.setTitle("0\nFollowers", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.numberOfLines = 2
        button.backgroundColor = .secondarySystemBackground
         return button
     }()
    
    private let followingButton : UIButton = {
        let button = UIButton()
        button.setTitle("0\nFollowing", for: .normal)
         button.layer.cornerRadius = 6
         button.layer.masksToBounds = true
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.numberOfLines = 2
        button.backgroundColor = .secondarySystemBackground
         return button
     }()
    
    
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        backgroundColor = .systemBackground
        addSubviews()
        configureButtons()
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapAvatar))
        avatarImageView.addGestureRecognizer(tap)
        avatarImageView.isUserInteractionEnabled = true

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let avatarSize : CGFloat = 130
        avatarImageView.frame = CGRect(x: (width-avatarSize)/2, y: 5, width: avatarSize, height: avatarSize)
        avatarImageView.layer.cornerRadius = avatarImageView.height/2
        
        followersButton.frame = CGRect(x: (width - 210)/2, y: avatarImageView.bottom + 10, width: 100, height: 60)
        followingButton.frame = CGRect(x: followersButton.right + 10, y: avatarImageView.bottom + 10, width: 100, height: 60)
        
        primaryButton.frame = CGRect(x: (width - 220)/2, y: followersButton.bottom + 15 , width: 220, height: 44)
        
    }

    func addSubviews() {
        addSubview(avatarImageView)
        addSubview(followersButton)
        addSubview(followingButton)
        addSubview(primaryButton)
    }
    
    func configureButtons(){
        primaryButton.addTarget(self, action: #selector(didTapPrimaryButton), for: .touchUpInside)
        
        followersButton.addTarget(self, action: #selector(didTapFollowersButton), for: .touchUpInside)
        
        followingButton.addTarget(self, action: #selector(didTapFollowingButton), for: .touchUpInside)
    }
    
    //MARK: - Action
    @objc func didTapPrimaryButton() {
        guard let viewModel = viewModel else {
            return
        }

        delegate?.profileCollectionReusableView(self, didTapPrimaryButtonWith: viewModel)
    }
    
    @objc func didTapFollowersButton() {
        guard let viewModel = viewModel else {
            return
        }

        delegate?.profileCollectionReusableView(self, didTapFollowersButtonWith: viewModel)
    }
    
    @objc func didTapFollowingButton() {
        guard let viewModel = viewModel else {
            return
        }

        delegate?.profileCollectionReusableView(self, didTapFollowingButtonWith: viewModel)
    }
    
    @objc func didTapAvatar() {
        guard let viewModel = viewModel else {
            return
        }
        delegate?.profileCollectionReusableView(self, didTapAvatarFor: viewModel)
    }

    
    func configure(with viewModel : ProfileHeaderViewModel){
        self.viewModel = viewModel
        //Setup Our header
        followersButton.setTitle("\(viewModel.followerCount)\nFollowers", for: .normal)
        followingButton.setTitle("\(viewModel.followingCount)\nFollowing", for: .normal)
        if let avatarURL = viewModel.avatarImageURL{
            //Dowload profile pic
            avatarImageView.sd_setImage(with: avatarURL, completed: nil)
        }
        else {
            avatarImageView.image = UIImage(named: "test")
        }
        
        if let isFollowing = viewModel.isFollowing {
            primaryButton.backgroundColor = isFollowing ? .secondarySystemBackground : .systemPink
            primaryButton.setTitle( isFollowing ? "Unfollow" : "Follow", for: .normal)
        } else {
            //Our own profile edit option
            primaryButton.backgroundColor = .secondarySystemBackground
            primaryButton.setTitle("Edit Profile", for: .normal)
        }
    }
    
}
