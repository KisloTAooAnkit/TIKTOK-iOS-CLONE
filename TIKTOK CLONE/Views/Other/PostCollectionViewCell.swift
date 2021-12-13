//
//  PostCollectionViewCell.swift
//  TIKTOK CLONE
//
//  Created by Ankit Singh on 03/12/21.
//

import UIKit
import AVFoundation

class PostCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "PostCollectionViewCell"
    
    private let imageView : UIImageView = {
       let imageV = UIImageView()
        imageV.clipsToBounds = true
        imageV.contentMode = .scaleAspectFill
        return imageV
    }()
    
    override init(frame : CGRect){
        super.init(frame: frame)
        clipsToBounds = true
        contentView.addSubview(imageView)
        contentView.backgroundColor = .secondarySystemGroupedBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
        
    }
    
    func configure(with post : PostModel){
        //Derive child path
        StorageManager.shared.getDownloadURL(for: post) { result in
            DispatchQueue.main.async {
                switch result{
                case .success(let url):
                    //Generate thumbnail
                    let asset = AVAsset(url: url)
                    let generator = AVAssetImageGenerator(asset: asset)
                    do {
                        let cgImage = try generator.copyCGImage(at: .zero, actualTime: nil)
                        self.imageView.image = UIImage(cgImage: cgImage)
                    }
                    catch {
                        
                    }
                    
                case .failure(let error):
                    print(error)
                }
            }
        }
        //Get download URL
        
        
        
    }
    
}
