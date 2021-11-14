//
//  ExploreCell.swift
//  TIKTOK CLONE
//
//  Created by Ankit Singh on 11/11/21.
//

import Foundation
import UIKit
enum ExploreCell{
    case banner(viewModel : ExploreBannerViewModel)
    case post(viewModel : ExplorePostViewModel)
    case hashtag(viewModel : ExploreHashtagViewModel)
    case user(viewModel : ExploreUserViewModel)
    
}
