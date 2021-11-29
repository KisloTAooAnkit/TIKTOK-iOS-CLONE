//
//  Notifications_PostCommentTableCell.swift
//  TIKTOK CLONE
//
//  Created by Ankit Singh on 25/11/21.
//

import UIKit
protocol PostCommentCellDelegate : AnyObject {
    func tappedOnPostCommentThumbnail(_ cell:Notifications_PostCommentTableCell,didTapPostwith identifier : String)
}


class Notifications_PostCommentTableCell: UITableViewCell {

    static let id : String = "Notifications_PostCommentTableCell"
    
    weak var delegate : PostCommentCellDelegate?
    
    var postId : String?
    
    private let postThumbnail : UIImageView = {
       let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let label : UILabel={
       let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .label
        return label
    }()
    
    
    private let dateLabel : UILabel={
       let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .secondaryLabel
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        contentView.addSubview(postThumbnail)
        contentView.addSubview(label)
        contentView.addSubview(dateLabel)
        selectionStyle = .none
        postThumbnail.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapPost))
        postThumbnail.addGestureRecognizer(tap)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        postThumbnail.frame = CGRect(x: contentView.width - 50,
                                     y: (contentView.height-50)/2,
                                     width: 50,
                                     height: contentView.height-6)
        
        postThumbnail.layer.cornerRadius = 25
        postThumbnail.layer.masksToBounds = true
        
        
        label.sizeToFit()
        dateLabel.sizeToFit()
        
        let labelSize = label.sizeThatFits(
            CGSize(width: contentView.width-10 - postThumbnail.width - 5,
                   height: contentView.height-40)
        )
        
        label.frame = CGRect(x: 10,
                             y: 0,
                             width: labelSize.width,
                             height: labelSize.height)
        
        dateLabel.frame = CGRect(x: 10,
                                 y: dateLabel.bottom+3,
                                 width: contentView.width - postThumbnail.width,
                                 height: 40)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        postThumbnail.image = nil
        label.text = nil
        dateLabel.text = nil
    }
    
    @objc private func didTapPost() {
        guard let postId = self.postId else {
            return
        }
        
        delegate?.tappedOnPostCommentThumbnail(self, didTapPostwith: postId)
    }
    
    
    func configureWith(with postFileName : String,model :Notification){
        postThumbnail.image = UIImage(named: "test")
        label.text  = nil
        dateLabel.text = .date(with: model.date)
        self.postId = postFileName
    }
}
