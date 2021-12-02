//
//  PostModel.swift
//  TIKTOK CLONE
//
//  Created by Ankit Singh on 05/11/21.
//

import Foundation

struct PostModel {
    let identifier : String
    
    let user : User
    var filename : String = ""
    var caption : String = ""
    
    var isLikedByCurrentUser = false
    
    
    static func mockModels() -> [PostModel] {
        var posts = [PostModel]()
        
        for _ in 0...100 {
            let post = PostModel(identifier: UUID().uuidString,
                                 user:User(username: "Ankit",
                                           profilePictureURL: nil,
                                           identifier: UUID().uuidString)
            )
            posts.append(post)
        }
        return posts
    }
}
