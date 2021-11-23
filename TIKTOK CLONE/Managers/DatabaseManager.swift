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
    
    public func getAllUsers(completion : ([String]) -> Void ) {
        
    }
    
}
