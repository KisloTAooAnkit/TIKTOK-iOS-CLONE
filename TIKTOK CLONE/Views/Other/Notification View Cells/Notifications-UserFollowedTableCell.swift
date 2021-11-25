//
//  Notifications-UserFollowedTableCell.swift
//  TIKTOK CLONE
//
//  Created by Ankit Singh on 25/11/21.
//

import UIKit

class Notifications_UserFollowedTableCell: UITableViewCell {

    static let id : String = "Notifications_UserFollowedTableCell"
    
    //avatar , label , followbutton on right side
    
    private let avatar : UIImageView = {
       let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let label : UILabel={
       let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .label
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatar.image = nil
        label.text = nil
    }
    
    
    func configureWith(with username : String){
        
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
