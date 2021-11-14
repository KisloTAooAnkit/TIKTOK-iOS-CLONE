//
//  ExploreHashtagViewModel.swift
//  TIKTOK CLONE
//
//  Created by Ankit Singh on 11/11/21.
//

import Foundation
import UIKit
struct ExploreHashtagViewModel{
    let text: String
    let icon : UIImage?
    let count : Int //number of post having this hashtag in them
    let handler : (()-> Void)
}
