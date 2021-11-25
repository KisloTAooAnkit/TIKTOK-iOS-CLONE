//
//  Notifications.swift
//  TIKTOK CLONE
//
//  Created by Ankit Singh on 25/11/21.
//

import Foundation


enum NotificationType{
    case postLike(postName:String)
    case userFollow(username:String)
    case postComment(postName:String)
    
    var id : String {
        switch self {
        case .postLike:
            return "postLike"
        case .userFollow:
            return "username"
        case .postComment:
            return "postComment"
        }
    }
}

struct Notification{
    let text : String
    let type : NotificationType
    let date : Date
    
    static func mockData() -> [Notification]{
        return Array(0...100).compactMap { index in
            Notification(text: "Something happened \(index)",
                         type: .userFollow(username: "Ankit"),
                         date: Date())
        }
    }
}
