//
//  StorageManager.swift
//  TIKTOK CLONE
//
//  Created by Ankit Singh on 30/10/21.
//

import Foundation
import FirebaseStorage

final class StorageManager {
    
    public static let shared = StorageManager()
    
    private let storageBucket = Storage.storage().reference()
    
    
    private init () {
        
    }
    
    //MARK: - Public
    public func getVideoURL(with identifier:String , completion  : (URL) -> Void ) {
        
    }
    
    public func uploadVideo(from url:URL,fileName:String,completion:@escaping (Bool)->Void){
        
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            return
        }
        
        storageBucket.child("videos/\(username)/\(fileName)").putFile(from: url, metadata: nil) { metadata, error in
            completion(error == nil)
        }
    }
    
    public func generateVideoName()->String {
        let uuidString = UUID().uuidString
        let number = Int.random(in: 0...1000)
        let unixTimeStamp = Date().timeIntervalSince1970
        
        return "\(uuidString)_\(number)_\(unixTimeStamp).mov"
    }
}
