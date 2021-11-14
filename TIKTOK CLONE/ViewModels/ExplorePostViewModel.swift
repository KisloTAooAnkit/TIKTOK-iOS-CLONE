//
//  ExplorePostViewModel.swift
//  TIKTOK CLONE
//
//  Created by Ankit Singh on 11/11/21.
//

import Foundation
import UIKit

struct ExplorePostViewModel{
    let thumbnailImage: UIImage?
    let caption : String
    let handler : (()-> Void)
}
