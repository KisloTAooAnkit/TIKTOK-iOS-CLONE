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
    public func getAllUsers(completion : ([String]) -> Void ) {
        
    }
    
}
