//
//  ViewController.swift
//  TIKTOK CLONE
//
//  Created by Ankit Singh on 30/10/21.
//

import UIKit

class HomeViewController: UIViewController {
    
    //MARK: - Properties
    
    let horizontalScrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.bounces = false
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    
     let control : UISegmentedControl = {
        let titles = ["Following","For You"]
        let control = UISegmentedControl(items: titles)
        control.selectedSegmentIndex = 1
         control.backgroundColor = nil
         control.selectedSegmentTintColor = .white
        return control
    }()
    
    let forYouPageViewController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .vertical,
        options: [:])
    
    let followingPageViewController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .vertical,
        options: [:])
    
    
    private var forYouPosts = PostModel.mockModels()
    private var followingPosts = PostModel.mockModels()
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        view.addSubview(horizontalScrollView)
        horizontalScrollView.delegate = self
        setupFeed()
        horizontalScrollView.contentOffset = CGPoint(x: view.width, y: 0)
        setupHeaderButtons()
        
    }
    
    
    func setupHeaderButtons(){

        control.addTarget(self, action: #selector(didChangeSegmentControl(_:)), for: .valueChanged)
        navigationItem.titleView = control
    }
    
    
    @objc private func didChangeSegmentControl(_ sender:UISegmentedControl){
        horizontalScrollView.setContentOffset(CGPoint(x: view.width * CGFloat(sender.selectedSegmentIndex),
                                                      y: 0),
                                              animated: true)
    }
    
    
    private func setupFeed(){
        horizontalScrollView.contentSize = CGSize(width: view.width, height: view.height)
        setUpFollowingFeed()
        setUpForYouFeed()
    }
    
    func setUpFollowingFeed(){
        guard let model = followingPosts.first else {
            return
        }
        let vc = PostViewController(model: model)
        vc.delegate = self
        followingPageViewController.setViewControllers(
            [vc],
            direction: .forward,
            animated: false,
            completion: nil)
        
        followingPageViewController.dataSource = self
        horizontalScrollView.addSubview(followingPageViewController.view)
        followingPageViewController.view.frame = CGRect(x: 0,
                                                        y: 0,
                                                        width: horizontalScrollView.width,
                                                        height: horizontalScrollView.height)
        addChild(followingPageViewController)
        followingPageViewController.didMove(toParent: self)
        
    }
    
    
    func setUpForYouFeed(){
        guard let model = forYouPosts.first else {
            return
        }
        let vc = PostViewController(model: model)
        vc.delegate = self
        forYouPageViewController.setViewControllers(
            [vc],
            direction: .forward,
            animated: false,
            completion: nil)
        
        forYouPageViewController.dataSource = self
        horizontalScrollView.addSubview(forYouPageViewController.view)
        forYouPageViewController.view.frame = CGRect(x: view.width,
                                                     y: 0,
                                                     width: horizontalScrollView.width,
                                                     height: horizontalScrollView.height)
        addChild(forYouPageViewController)
        forYouPageViewController.didMove(toParent: self)
        
    }
    
    
    internal override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        horizontalScrollView.frame = view.bounds
    }
    
}

extension HomeViewController : UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let fromPost = (viewController as? PostViewController)?.model else {
            return nil
        }
        guard let index = currentPosts.firstIndex(where: {
            $0.identifier == fromPost.identifier
        }) else {
            return nil
        }
        
        if index == 0 {
            return nil
        }
        let priorIndex = index - 1
        let model = currentPosts[priorIndex]
        let vc = PostViewController(model:model)
        vc.delegate = self
        return vc
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let fromPost = (viewController as? PostViewController)?.model else {
            return nil
        }
        guard let index = currentPosts.firstIndex(where: {
            $0.identifier == fromPost.identifier
        }) else {
            return nil
        }
        
        if index == currentPosts.count - 1 {
            return nil
        }
        let nextIdx = index + 1
        let model = currentPosts[nextIdx]
        let vc = PostViewController(model:model)
        vc.delegate = self
        return vc
    }
    
    var currentPosts : [PostModel]{
        if horizontalScrollView.contentOffset.x == 0 {
            //Following
            return followingPosts
        }
        else {
            //For you
            return forYouPosts
        }
    }
}
extension HomeViewController : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x < (view.width/2) {
            control.selectedSegmentIndex = 0
        }
        else if scrollView.contentOffset.x > (view.width/2) {
            control.selectedSegmentIndex = 1
        }
    }
}

extension HomeViewController : PostViewControllerDelegate{
    
    func postViewController(_ vc: PostViewController, didTapProfileButton post: PostModel) {
        let user =  post.user
        let vc = ProfileViewController(user: user)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func postViewController(_ vc: PostViewController, didTapCommentButtonFor post: PostModel) {
        horizontalScrollView.isScrollEnabled = false
        
        if horizontalScrollView.contentOffset.x == 0 {
            //following page
            followingPageViewController.dataSource = nil
        }
        else {
            //for you page
            forYouPageViewController.dataSource = nil
        }
        
        
        let vc = CommentViewController(post: post)
        vc.delegate = self
        addChild(vc)
        vc.didMove(toParent: self)
        view.addSubview(vc.view)
        let frame = CGRect(x: 0, y: view.height, width: view.width, height: view.height*0.76)
        vc.view.frame = frame
        UIView.animate(withDuration: 0.2) {
            vc.view.frame = CGRect(x: 0, y: self.view.height - frame.height, width: frame.width, height: frame.height)
        }
    }
    
    
}

extension HomeViewController : CommentViewControllerDelegate {
    func didTapCloseCommentsButton(with viewController: CommentViewController) {
        //close Comments with animation
        let frame = viewController.view.frame
        
        UIView.animate(withDuration: 0.2) {
            viewController.view.frame = CGRect(x: 0, y: self.view.height, width: frame.width, height: frame.height)
        } completion: { [weak self]  done in
            if done {
                DispatchQueue.main.async {
                    //allow scrolling horiz and vertical
                    self?.horizontalScrollView.isScrollEnabled = true
                    self?.followingPageViewController.dataSource  = self
                    self?.forYouPageViewController.dataSource = self
                    //remove this child
                    viewController.view.removeFromSuperview()
                    viewController.removeFromParent()
                }

            }
        }

    }
}
