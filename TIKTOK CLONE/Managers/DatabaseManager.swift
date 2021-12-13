//
//  DatabaseManager.swift
//  TIKTOK CLONE
//
//  Created by Ankit Singh on 30/10/21.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager {
    public static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
    
    private init () {
        
    }
    
    //MARK: - Public
    
    public func insertUser(with email : String ,username : String,completion : @escaping (Bool)->Void){
        
        database.child("users").observeSingleEvent(of: .value) { [weak self] snapshot in
            guard var usersDict = snapshot.value as? [String : Any] else {
                //create user when database is empty
                self?.database.child("users").setValue([
                        username : [
                            "email" : email
                        ]
                ]) { error, _ in
                    completion(error == nil)
                }
                return
            }
            
            //insert fresh user when database has already few values in it
            usersDict[username] = ["email":email]
            self?.database.child("users").setValue(usersDict,withCompletionBlock: { error, _ in
                return completion(error==nil)
            })
        }
    }
    
    public func getUserName(for email : String, completion : @escaping (String?)->Void){
        database.child("users").observeSingleEvent(of: .value) { snapshot in
            guard let users = snapshot.value as? [String:[String :Any]]  else {
                return
            }

            for (username,value) in users{
                if value["email"] as? String == email {
                    completion(username)
                    break
                }
                
            }
        }
        
    }
    
    
    public func insertPostName(filename : String ,caption : String, completion :@escaping (Bool)-> Void){
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            completion(false)
            return
        }
        database.child("users").child(username).observeSingleEvent(of: .value) {[weak self] snapshot in
            guard var value = snapshot.value as? [String : Any] else {
                completion(false)
                return
            }
            
            let newEntry = [
                "name":filename,
                "caption": caption
            ]
            if var posts = value["posts"] as? [[String:Any]] {
                posts.append(newEntry)
                value["posts"] = posts
                self?.database.child("users").child(username).setValue(value) { error, databaseRef in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    completion(true)
                }
            }
            else {
                
                value["posts"] = [newEntry]
                self?.database.child("users").child(username).setValue(value) { error, databaseRef in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    completion(true)
                }
            }
        }
    }
    

    
    public func getPosts(for user:User , completion : @escaping ([PostModel])->Void){
        
        
        let path = "users/\(user.username)/posts"
        print(path)
        database.child(path).observeSingleEvent(of: .value) { snapshot in
            guard let posts = snapshot.value as? [[String:String]] else {
                completion([])
                return
            }
        
            let models : [PostModel] = posts.compactMap { dict in
                var model = PostModel(identifier: UUID().uuidString, user: user)
                model.filename = dict["name"] as? String ?? ""
                model.caption = dict["caption"] as? String ?? ""
                return model
            }
            
            completion(models)
        }
    }
    
    
    public func getRelationships(
        for user : User ,
        type : UserListViewController.ListType,
        completion : @escaping ([String]) -> Void) {
            let path = "users/\(user.username.lowercased())/\(type.rawValue)"
            print("Fetching data from \(path)")
//            let newPath = "users/\(user.username)"
//            database.child(newPath).observeSingleEvent(of: .value) { snapshot in
//                guard let data = snapshot.value as? [String:Any] else {
//                    return
//                }
//                
//            }
            
            database.child(path).observeSingleEvent(of: .value) { snapshot in
                guard let usernameCollection = snapshot.value as? [String] else {
                    completion([])
                    return
                }
                completion(usernameCollection)
            }
    }
    
    /// Check if a relationship is valid
    /// - Parameters:
    ///   - user: Target user to check
    ///   - type: Type to check
    ///   - completion: Result callback
    public func isValidRelationship(
        for user: User,
        type: UserListViewController.ListType,
        completion: @escaping (Bool) -> Void
    ) {
        guard let currentUserUsername = UserDefaults.standard.string(forKey: "username")?.lowercased() else {
            return
        }

        let path = "users/\(user.username.lowercased())/\(type.rawValue)"

        database.child(path).observeSingleEvent(of: .value) { snapshot in
            guard let usernameCollection = snapshot.value as? [String] else {
                completion(false)
                return
            }

            completion(usernameCollection.contains(currentUserUsername))
        }
    }
    
    /// Update follow status for user
    /// - Parameters:
    ///   - user: Target user
    ///   - follow: Follow or unfollow status
    ///   - completion: Result callback
    public func updateRelationship(
        for user: User,
        follow: Bool,
        completion: @escaping (Bool) -> Void
    ) {
        guard let currentUserUsername = UserDefaults.standard.string(forKey: "username")?.lowercased() else {
            return
        }

        if follow {
            // follow

            // Insert into current user's following
            let path = "users/\(currentUserUsername)/following"
            database.child(path).observeSingleEvent(of: .value) { (snapshot) in
                let usernameToInsert = user.username.lowercased()
                if var current = snapshot.value as? [String] {
                    current.append(usernameToInsert)
                    self.database.child(path).setValue(current) { error, _ in
                        completion(error == nil)
                    }
                } else {
                    self.database.child(path).setValue([usernameToInsert]) { error, _ in
                        completion(error == nil)
                    }
                }
            }

            // Insert in target users followers
            let path2 = "users/\(user.username.lowercased())/followers"
            database.child(path2).observeSingleEvent(of: .value) { (snapshot) in
                let usernameToInsert = currentUserUsername.lowercased()
                if var current = snapshot.value as? [String] {
                    current.append(usernameToInsert)
                    self.database.child(path2).setValue(current) { error, _ in
                        completion(error == nil)
                    }
                } else {
                    self.database.child(path2).setValue([usernameToInsert]) { error, _ in
                        completion(error == nil)
                    }
                }
            }
        } else {
            // unfollow

            // Remove from current user following
            let path = "users/\(currentUserUsername)/following"
            database.child(path).observeSingleEvent(of: .value) { (snapshot) in
                let usernameToRemove = user.username.lowercased()
                if var current = snapshot.value as? [String] {
                    current.removeAll(where: { $0 == usernameToRemove })
                    self.database.child(path).setValue(current) { error, _ in
                        completion(error == nil)
                    }
                }
            }

            // Remove in target users followers
            let path2 = "users/\(user.username.lowercased())/followers"
            database.child(path2).observeSingleEvent(of: .value) { (snapshot) in
                let usernameToRemove = currentUserUsername.lowercased()
                if var current = snapshot.value as? [String] {
                    current.removeAll(where: { $0 == usernameToRemove })
                    self.database.child(path2).setValue(current) { error, _ in
                        completion(error == nil)
                    }
                }
            }
        }
    }
    
    public func markNotificationAsHidden(notificationID:String, completion : @escaping (Bool)->Void){
        completion(true)
    }
    
    public func getNotifications(completion : @escaping ([Notification])->Void){
        completion(Notification.mockData())
    }
    
    public func follow(username : String , completion : @escaping (Bool) -> Void){
        completion(true)
    }
    
}
