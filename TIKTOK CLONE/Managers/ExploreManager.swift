//
//  ExploreManager.swift
//  TIKTOK CLONE
//
//  Created by Ankit Singh on 11/11/21.
//

import Foundation
import UIKit

protocol ExploreManagerDelegate : AnyObject {
    func pushViewController(_ vc:UIViewController)
    func didTapHashtag(_ hashtag:String)
}

final class ExploreManager {
    static let shared = ExploreManager()
    
    
    weak var delegate: ExploreManagerDelegate?
    
    enum BannerAction : String {
        case post
        case hashtag
        case user
    }
    
    
    //MARK: - Banners
    public func getExploreBanners() -> [ExploreBannerViewModel]{
        guard let exploreData = parseExploreData() else {
            return  []
        }
        return exploreData.banners.compactMap { banner in
            ExploreBannerViewModel(
                imageView: UIImage(named: banner.image),
                title: banner.title) { [weak self] in
                    guard let action = BannerAction(rawValue: banner.action) else {
                        return
                    }
                    DispatchQueue.main.async {
                        let vc = UIViewController()
                        vc.view.backgroundColor = .red
                        vc.title = action.rawValue.uppercased()
                        self?.delegate?.pushViewController(vc)
                    }
                    switch action {
                    case .post:
                        //post
                        break
                    case .hashtag:
                        //search for hashtag
                        break
                    case .user:
                        //profile
                        break
                    }
                }
        }
    }
    //MARK: - Creators
    public func getExploreCreators() -> [ExploreUserViewModel]{
        guard let exploreData = parseExploreData() else {
            return  []
        }
        return exploreData.creators.compactMap { creator in
            ExploreUserViewModel(
                username: creator.username,
                profilePictureImage: UIImage(named: creator.image),
                followerCount: creator.followers_count) { [weak self] in
                    
                    DispatchQueue.main.async {
                        let userId = creator.id
                        //Todo:: Fetch user object from firebase
                        let vc = ProfileViewController(user: User(username: "John", profilePictureURL: nil, identifier: userId))
                        self?.delegate?.pushViewController(vc)
                    }

                }
        }
    }
    
    //MARK: - Hashtags
    public func getExploreHashtags() -> [ExploreHashtagViewModel]{
        guard let exploreData = parseExploreData() else {
            return  []
        }
        return exploreData.hashtags.compactMap { hashtag in
            ExploreHashtagViewModel(text: "#" + hashtag.tag,
                                    icon: UIImage(systemName: hashtag.image),
                                    count: hashtag.count) { [weak self] in
                DispatchQueue.main.async {
                    self?.delegate?.didTapHashtag(hashtag.tag)

                }
            }
        }
    }
    //MARK: - Recents Post
    public func getExploreRecents() -> [ExplorePostViewModel]{
        guard let exploreData = parseExploreData() else {
            return  []
        }
        return exploreData.recentPosts.compactMap { recentPost in
            ExplorePostViewModel(thumbnailImage: UIImage(named: recentPost.image),
                                 caption: recentPost.caption) { [weak self] in
                DispatchQueue.main.async {
                    //use id to fetch post from firebase
                    let user = User(username: "Ankit",
                                    profilePictureURL: nil,
                                    identifier: UUID().uuidString)
                    let postId = recentPost.id
                    let vc = PostViewController(model: PostModel(identifier: postId, user: user))
                    self?.delegate?.pushViewController(vc)
                }

            }
        }
    }
    
    //MARK: - Trending Post
    public func getExploreTrendingPosts() -> [ExplorePostViewModel]{
        guard let exploreData = parseExploreData() else {
            return  []
        }
        return exploreData.trendingPosts.compactMap { trendingPost in
            ExplorePostViewModel(thumbnailImage: UIImage(named: trendingPost.image),
                                 caption: trendingPost.caption) {[weak self] in
                DispatchQueue.main.async {
                    //use id to fetch post from firebase
                    let user = User(username: "Ankit",
                                    profilePictureURL: nil,
                                    identifier: UUID().uuidString)
                    let postId = trendingPost.id
                    let vc = PostViewController(model: PostModel(identifier: postId, user: user))
                    self?.delegate?.pushViewController(vc)
                }
                
            }
        }
    }
    
    //MARK: - Popular
    public func getExplorePopularPosts() -> [ExplorePostViewModel]{
        guard let exploreData = parseExploreData() else {
            return  []
        }
        return exploreData.popular.compactMap { popularPost in
            ExplorePostViewModel(thumbnailImage: UIImage(named: popularPost.image),
                                 caption: popularPost.caption) { [weak self] in
                DispatchQueue.main.async {
                    //use id to fetch post from firebase
                    let user = User(username: "Ankit",
                                    profilePictureURL: nil,
                                    identifier: UUID().uuidString)
                    let postId = popularPost.id
                    let vc = PostViewController(model: PostModel(identifier: postId, user: user))
                    self?.delegate?.pushViewController(vc)
                }
                
            }
        }
    }
    
    //MARK: - Recommended
    public func getExploreRecommendedPosts() -> [ExplorePostViewModel]{
        guard let exploreData = parseExploreData() else {
            return  []
        }
        return exploreData.recommended.compactMap { recommendedPost in
            ExplorePostViewModel(thumbnailImage: UIImage(named: recommendedPost.image),
                                 caption: recommendedPost.caption) { [weak self] in
                DispatchQueue.main.async {
                    //use id to fetch post from firebase
                    let user = User(username: "Ankit",
                                    profilePictureURL: nil,
                                    identifier: UUID().uuidString)
                    let postId = recommendedPost.id
                    let vc = PostViewController(model: PostModel(identifier: postId,user:user))
                    self?.delegate?.pushViewController(vc)
                }
                
            }
        }
    }
    
    
    //MARK: - Json Parser
    private func parseExploreData() -> ExploreResponse? {
        guard let path = Bundle.main.path(forResource: "explore", ofType: "json") else {
            return nil
        }
        do {
            let url = URL(fileURLWithPath: path)
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(ExploreResponse.self, from: data)
        }
        catch{
            print(error)
            return nil
        }
    }
}

struct ExploreResponse : Codable {
    let banners : [Banner]
    let trendingPosts : [Post]
    let creators : [Creator]
    let recentPosts : [Post]
    let hashtags : [Hashtag]
    let popular : [Post]
    let recommended : [Post]
    
}
struct Banner : Codable {
    let  id  : String
    let image : String
    let title : String
    let action : String
}

struct Post : Codable {
    let id : String
    let image : String
    let caption : String
}

struct Hashtag :Codable {
    let image : String
    let tag : String
    let count : Int
}

struct Creator : Codable {
    let id : String
    let image : String
    let username : String
    let followers_count : Int
}
