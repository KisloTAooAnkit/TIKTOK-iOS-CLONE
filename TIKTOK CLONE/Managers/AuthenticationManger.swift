//
//  AuthenticationManger.swift
//  TIKTOK CLONE
//
//  Created by Ankit Singh on 30/10/21.
//

import Foundation
import FirebaseAuth

final class AuthManager {
    
    public static let shared = AuthManager()
    
    public var isSignedIn : Bool {
        return Auth.auth().currentUser != nil
    }
    
    enum SignInMethod {
        case email
        case facebook
        case gmail
    }
    
    private init () {
        
    }
    
    //MARK: - Public
    public func getVideoURL(with identifier:String , completion  : (URL) -> Void ) {
        
    }
    
    public func uploadVideo(from url:URL){
        
    }
    
    public func signIn(with email : String , password: String,completion : @escaping (Bool)->Void) {
        
    }
    
    public func signOut(completion : (Bool)->Void) {
        do{
            try Auth.auth().signOut()
            completion(true)
        }
        catch{
            print(error)
            completion(false)
        }
    }
    
}
