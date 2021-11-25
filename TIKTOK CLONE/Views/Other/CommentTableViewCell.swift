//
//  CommentTableViewCell.swift
//  TIKTOK CLONE
//
//  Created by Ankit Singh on 07/11/21.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    static let identifier = "CommentTableViewCell"
    
    private let avatarImageView : UIImageView = {
       let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let commentLabel : UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .label
        return label
    }()
    
    private let dateLabel : UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        label.font = UIFont(name: "Avenir-Light", size: 12)
        return label
    }()

    private lazy var dateCommentStackView : UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [ dateLabel,
                                                        commentLabel])
        stackView.distribution = .fillProportionally
        stackView.alignment = .top
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        clipsToBounds = true
        contentView.addSubview(avatarImageView)
//        contentView.addSubview(commentLabel)
//        contentView.addSubview(dateLabel)
        contentView.addSubview(dateCommentStackView)

        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        commentLabel.sizeToFit()
        dateLabel.sizeToFit()
        layoutCommentFields()
        
    }
    
    func layoutCommentFields(){
        //Setup Image View
        let imageSize : CGFloat =  70
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        commentLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            avatarImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 10),
            avatarImageView.heightAnchor.constraint(equalToConstant: imageSize),
            avatarImageView.widthAnchor.constraint(equalToConstant: imageSize)
        ])
        //SetupDate And Comment Label
        dateCommentStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateCommentStackView.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 5),
            dateCommentStackView.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor,constant: 10)
        ])
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        dateLabel.text = nil
        commentLabel.text = nil
        avatarImageView.image = nil
    }
    
    public func configure(with model : PostComment){
        commentLabel.text = model.text
        dateLabel.text = .date(with: model.date)
        if let url = model.user.profilePictureURL{
            print(url)
        }
        else {
            avatarImageView.image = UIImage(systemName: "person.circle")
        }
    }
}
