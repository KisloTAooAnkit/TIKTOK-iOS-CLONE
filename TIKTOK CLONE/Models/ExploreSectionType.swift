//
//  ExploreSectionType.swift
//  TIKTOK CLONE
//
//  Created by Ankit Singh on 11/11/21.
//

import Foundation
enum ExploreSectionType : CaseIterable{
    case banners
    case trendingPosts
    case users
    case trendingHashtags
    case recommended
    case popular
    case new
    
    var title : String {
        switch self {
            
        case .users:
            return "Popular Creators"
        case .banners:
            return "Featured"
        case .trendingPosts:
            return "Trending Videos"
        case .trendingHashtags:
            return "Hashtags"
        case .recommended:
            return "Recommended"
        case .popular:
            return "Popular"
        case .new:
            return "Recently Posted"
        }
    }
}

