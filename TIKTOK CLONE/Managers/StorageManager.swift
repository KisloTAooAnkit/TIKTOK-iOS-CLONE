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
    
    private let storage = Storage.storage().reference()
    
    
    private init () {
        
    }
    
    //MARK: - Public
    public func getVideoURL(with identifier:String , completion  : (URL) -> Void ) {
        
    }
    
    public func uploadVideo(from url:URL){
        
    }
}
