//
//  ExploreUserViewModel.swift
//  TIKTOK CLONE
//
//  Created by Ankit Singh on 11/11/21.
//

import Foundation
import UIKit

struct ExploreUserViewModel{
    let username: String
    let profilePictureImage : UIImage?
    let followerCount : Int
    let handler : (()-> Void)
}
