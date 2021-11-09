//
//  PostComment.swift
//  TIKTOK CLONE
//
//  Created by Ankit Singh on 06/11/21.
//

import Foundation
struct PostComment {
    let text : String
    let user: User
    let date : Date
    
    static func mockComments() -> [PostComment]{
        let user = User(username: "Ankit Singh",
                        profilePictureURL: nil,
                        identifier: UUID().uuidString)
        
        
        let text = [
            "This is cool",
            "Already hating this post",
            "Sheeeeeeesh !!",
            "Dayumm son where'd you find this ? "
        ]
        
        var comments = [PostComment]()
        for comment in text {
            comments.append(
                PostComment(text: comment,
                            user: user,
                            date: Date()))
        }
        return comments
    }
}
