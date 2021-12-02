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
    
    public func getAllUsers(completion : ([String]) -> Void ) {
        
    }
    
    public func getPosts(for user:User , completion : @escaping ([PostModel])->Void){
        
        
        let path = "user/\(user.username)/posts"
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
