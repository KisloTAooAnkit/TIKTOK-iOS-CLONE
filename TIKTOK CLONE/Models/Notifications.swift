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

class Notification{
    var identifier = UUID().uuidString
    var isHidden = false
    let text : String
    let type : NotificationType
    let date : Date
    
    
    init(text : String,type:NotificationType,date : Date) {
        self.text = text
        self.type = type
        self.date = date
    }
    
    static func mockData() -> [Notification]{
       let first =  Array(0...7).compactMap { index in
            Notification(text: "Something happened \(index)",
                         type: .userFollow(username: "Ankit"),
                         date: Date())
        }
        let second =  Array(0...7).compactMap { index in
             Notification(text: "Something happened \(index)",
                          type: .postLike(postName: "LLLLLLL"),
                          date: Date())
         }
        let third =  Array(0...7).compactMap { index in
             Notification(text: "Something happened \(index)",
                          type: .postComment(postName: "AAAAAA"),
                          date: Date())
         }
        
        return second + first + third
    }
}
