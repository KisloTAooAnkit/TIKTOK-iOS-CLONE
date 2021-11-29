//
//  Notifications-UserFollowedTableCell.swift
//  TIKTOK CLONE
//
//  Created by Ankit Singh on 25/11/21.
//

import UIKit

protocol UserFollowedCellDelegate : AnyObject {
    func notifications_UserFollowedTableCell(_ cell:Notifications_UserFollowedTableCell,
                                             didTapFollowFor username:String)
    
    func notifications_UserFollowedTableCell(_ cell:Notifications_UserFollowedTableCell,
                                             didTapAvatarFor username:String)
}


class Notifications_UserFollowedTableCell: UITableViewCell {

    static let id : String = "Notifications_UserFollowedTableCell"
    
     weak var delegate: UserFollowedCellDelegate?
    //avatar , label , followbutton on right side
    
    private var username : String?
    
    private let avatar : UIImageView = {
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
    
    
    private let followButton: UIButton = {
       let button = UIButton()
        button.setTitle("Follow", for: .normal)
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.layer.cornerRadius = 6
        button.layer.masksToBounds = true
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        contentView.addSubview(avatar)
        contentView.addSubview(label)
        contentView.addSubview(followButton)
        contentView.addSubview(dateLabel)
        selectionStyle = .none
        followButton.addTarget(self, action: #selector(didTapFollow), for: .touchUpInside)
        avatar.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapAvatar))
        avatar.addGestureRecognizer(tap)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let iconSize : CGFloat = 50
        
        avatar.frame = CGRect(x: 10,
                              y: (contentView.height-iconSize)/2,
                              width: iconSize,
                              height: iconSize)
        
        avatar.layer.cornerRadius = 25
        avatar.layer.masksToBounds = true
        followButton.sizeToFit()
        followButton.frame = CGRect(x: contentView.width - 100 - 10,
                                    y: (contentView.height - 50)/2,
                                    width: 100,
                                    height: 30)
        
        label.sizeToFit()
        dateLabel.sizeToFit()
        
        let labelSize = label.sizeThatFits(
            CGSize(width: contentView.width-30-followButton.width-iconSize,
                   height: contentView.height-40)
        )
        
        label.frame = CGRect(x: avatar.right+10,
                             y: 0,
                             width: labelSize.width,
                             height: labelSize.height)
        
        dateLabel.frame = CGRect(x: avatar.right+10,
                                 y: dateLabel.bottom+3,
                                 width: contentView.width - avatar.width - followButton.width,
                                 height: 40)

    
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatar.image = nil
        label.text = nil
        dateLabel.text = nil
        followButton.setTitle("Follow", for: .normal)
        followButton.backgroundColor = .systemBlue
        followButton.layer.borderColor = nil
        followButton.layer.borderWidth = 0

    }
    
    @objc func didTapAvatar() {
        guard let username = username else {
            return
        }
        delegate?.notifications_UserFollowedTableCell(self, didTapAvatarFor: username)
    }
    
    @objc func didTapFollow(){
        guard let username = username else {
            return
        }
        followButton.setTitle("Following", for: .normal)
        followButton.backgroundColor = .clear
        followButton.layer.borderColor = UIColor.lightGray.cgColor
        followButton.layer.borderWidth = 1
        delegate?.notifications_UserFollowedTableCell(self, didTapFollowFor: username)
    }
    
    func configureWith(with username : String,model :Notification){
        avatar.image = UIImage(named: "test")
        label.text = model.text
        dateLabel.text = .date(with: model.date)
        self.username = username
    }
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}
