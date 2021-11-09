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
    
    public func signIn(with method : SignInMethod){
        
    }
    
    public func signOut() {
        
    }
    
}
