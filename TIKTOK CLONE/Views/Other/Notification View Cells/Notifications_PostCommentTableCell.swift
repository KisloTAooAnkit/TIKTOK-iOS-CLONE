//
//  Notifications_PostCommentTableCell.swift
//  TIKTOK CLONE
//
//  Created by Ankit Singh on 25/11/21.
//

import UIKit

class Notifications_PostCommentTableCell: UITableViewCell {

    static let id : String = "Notifications_PostCommentTableCell"
    
    private let postThumbnail : UIImageView = {
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
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        contentView.addSubview(postThumbnail)
        contentView.addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        postThumbnail.image = nil
        label.text = nil
    }
    
    func configureWith(with postFileName : String){
        
    }
}
