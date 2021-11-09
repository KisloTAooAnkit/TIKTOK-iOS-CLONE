//
//  CommentViewController.swift
//  TIKTOK CLONE
//
//  Created by Ankit Singh on 06/11/21.
//

import UIKit

protocol CommentViewControllerDelegate : AnyObject{
    func didTapCloseCommentsButton(with viewController : CommentViewController)
}


class CommentViewController: UIViewController {

    private let post : PostModel
    
    private var comments = [PostComment]()
    
    weak var delegate : CommentViewControllerDelegate?
    
    private let closeButton : UIButton = {
       let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private let tableView : UITableView = {
        let tableView = UITableView()
        tableView.register(CommentTableViewCell.self,
                           forCellReuseIdentifier: CommentTableViewCell.identifier)
        return tableView
    }()
    
    
    init(post : PostModel){
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(closeButton)
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = .white
        closeButton.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
        fetchPostComments()
        
    }
    
    @objc private func didTapClose() {
        delegate?.didTapCloseCommentsButton(with: self )
    }

    
    func fetchPostComments(){
        self.comments = PostComment.mockComments()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        closeButton.frame = CGRect(x: view.width - 60, y: 10, width: 35, height: 35)
        tableView.frame = CGRect(x: 0,
                                 y: closeButton.bottom,
                                 width: view.width,
                                 height: view.height - closeButton.bottom)
        
    }
    
}

extension CommentViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let comment = self.comments [indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentTableViewCell.identifier,for: indexPath) as? CommentTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: comment)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
