//
//  PostViewController.swift
//  TIKTOK CLONE
//
//  Created by Ankit Singh on 30/10/21.
//

import UIKit
import AVFoundation

protocol PostViewControllerDelegate : AnyObject {
    func postViewController(_ vc: PostViewController, didTapCommentButtonFor post : PostModel)
    func postViewController(_ vc: PostViewController, didTapProfileButton post : PostModel)
}


class PostViewController: UIViewController {

    //MARK: - Properties
    var model : PostModel
    
    weak var delegate : PostViewControllerDelegate?
    
    private let likeButton :  UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "heart.fill"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .white
        return button
    }()
    
    private let commentButton :  UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "text.bubble.fill"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .white
        return button
    }()
    
    private let shareButton :  UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .white
        return button
    }()
    
    private let profileButton :  UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "test"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .white
        return button
    }()

    
    
    private let captionLabel : UILabel = {
       let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 22)
        label.text = "Check out this video #foryou #foryoupage Check out this video #foryou #foryoupage Check out this video #foryou #foryoupage"
        label.textColor = .white
        return label
    }()
    
    
    var player : AVPlayer?
    
    //MARK: - Init
    init(model : PostModel){
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVideo()
        let colors  : [UIColor] = [
            .gray,
            .green,
            .blue,
            .brown,
            .black,
            .systemPink
        ]
        view.backgroundColor = colors.randomElement()
        setupButtons()
        setupDoubleTapToLike()
        view.addSubview(captionLabel)

        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let size : CGFloat = 40
        let yStart : CGFloat = view.height - (size*4) - 30 - view.safeAreaInsets.bottom - (tabBarController?.tabBar.height ?? 0)
        for (index,button) in [likeButton,commentButton,shareButton].enumerated(){
            button.frame = CGRect(x: view.width - size - 10,
                                  y: yStart + (CGFloat(index)*size) + (CGFloat(index)*10) ,
                                  width: size,
                                  height: size)
        }
        
        captionLabel.sizeToFit()
        let labelSize = captionLabel.sizeThatFits(CGSize(width:  view.width - size - 12, height: view.height))
        captionLabel.frame = CGRect(x: 5,
                                    y: view.height - 10 - view.safeAreaInsets.bottom - labelSize.height - (tabBarController?.tabBar.height ?? 0),
                                    width: view.width - size - 12,
                                    height: labelSize.height)
        
        profileButton.frame = CGRect(x: likeButton.left,
                                     y: likeButton.top - 10 - size,
                                     width: size,
                                     height: size)
        profileButton.layer.cornerRadius = 20
    }
    
    func setupButtons(){
        view.addSubview(likeButton)
        view.addSubview(commentButton)
        view.addSubview(shareButton)
        view.addSubview(profileButton)
        likeButton.addTarget(self, action: #selector(didTapLike), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(didTapShare), for: .touchUpInside)
        commentButton.addTarget(self, action: #selector(didTapComment), for: .touchUpInside)
        profileButton.addTarget(self, action: #selector(didTapProfileButton), for: .touchUpInside)
        
        
    }
    
    func setupDoubleTapToLike(){
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(didDoubleTap(_:)))
        tap.numberOfTapsRequired = 2
        view.addGestureRecognizer(tap)
        view.isUserInteractionEnabled = true
    }
    
    
    private func configureVideo(){
        guard let path = Bundle.main.path(forResource: "video", ofType: "mp4") else {
            return
        }
        let url  = URL(fileURLWithPath: path)
        player = AVPlayer(url: url)
        
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = view.bounds
        playerLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(playerLayer)
        player?.volume = 0
        
        player?.play()
    }
    
    @objc private func didDoubleTap(_ gesture : UITapGestureRecognizer ){
        if !model.isLikedByCurrentUser {
            model.isLikedByCurrentUser = true
            likeButton.tintColor = model.isLikedByCurrentUser ? .systemRed : .white
        }
        
        let touchPoint = gesture.location(in: view)
        
        let imageView = UIImageView(image: UIImage(systemName: "heart.fill"))
        imageView.tintColor = .systemRed
        imageView.frame = CGRect(x:0,y:0,width: 100,height: 100)
        imageView.center = touchPoint
        imageView.contentMode = .scaleAspectFit
        imageView.alpha = 0
        view.addSubview(imageView)
        
        UIView.animate(withDuration: 0.2) {
            imageView.alpha = 1
        } completion: { done in
            if done {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                    UIView.animate(withDuration: 0.3) {
                        imageView.alpha = 0
                    } completion: { done in
                        if done {
                            imageView.removeFromSuperview()
                        }
                    }
                })
            }
        }

        
    }
    
    @objc private func didTapProfileButton(){
        delegate?.postViewController(self, didTapProfileButton: model)
    }
    
    @objc private func didTapLike() {
        model.isLikedByCurrentUser = !model.isLikedByCurrentUser
        
        likeButton.tintColor = model.isLikedByCurrentUser ? .systemRed : .white
    }
    
    @objc private func didTapShare() {
        guard let url = URL(string: "https://www.tiktok.com") else {
            return
        }
        
        let vc = UIActivityViewController(
            activityItems: [url],
            applicationActivities: [])
        
        present(vc, animated: true, completion: nil)
        
    }
    
    @objc private func didTapComment() {
        
        delegate?.postViewController(self, didTapCommentButtonFor: model)
    }
    


}
