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
    
    public func uploadVideo(from url:URL,fileName:String,completion:@escaping (Bool)->Void){
        
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            return
        }
        
        storageBucket.child("videos/\(username)/\(fileName)").putFile(from: url, metadata: nil) { metadata, error in
            completion(error == nil)
        }
    }
    
    public func uploadProfilePicture(with image : UIImage , completion: @escaping (Result<URL,Error>)->Void){
        
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            return
        }
        guard let imageData = image.pngData() else {
            return
        }
        let path = "Profile_Pictures/\(username)/picture.png"
        
        storageBucket.child(path).putData(imageData,metadata: nil) { metaData, error in
            if let error = error {
                completion(.failure(error))
            }
            else {
                self.storageBucket.child(path).downloadURL { url, error in
                    guard let url = url else {
                        if let error = error {
                            completion(.failure(error))
                        }
                        return
                    }
                    completion(.success(url))

                }
            }
        }
    }
    
    public func generateVideoName()->String {
        let uuidString = UUID().uuidString
        let number = Int.random(in: 0...1000)
        let unixTimeStamp = Date().timeIntervalSince1970
        
        return "\(uuidString)_\(number)_\(unixTimeStamp).mov"
    }
    
    func getDownloadURL(for post:PostModel , completion : @escaping (Result<URL,Error>) -> Void){
        storageBucket.child(post.videoChildPath).downloadURL { url, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let url = url {
                completion(.success(url))
            }
        }
    }
}
