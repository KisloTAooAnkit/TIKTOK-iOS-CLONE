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
    
    enum AuthError : Error {
        case signInFailed
    }
    
    private init () {
        
    }
    
    //MARK: - Public
    public func getVideoURL(with identifier:String , completion  : (URL) -> Void ) {
        
    }
    
    public func uploadVideo(from url:URL){
        
    }
    
    public func signIn(with email : String , password: String,completion : @escaping (Result<String, Error>)->Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            guard let result = result , error  == nil else {
                if let error = error {
                    completion(.failure(error))
                }
                else {
                    completion(.failure(AuthError.signInFailed))
                }
                return
            }
            //successfull sign in
            completion(.success(email))
        }
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
    
    public func signUp(
        with username: String,
        emailAddress : String ,
        password : String,
        completion : @escaping(Bool) -> Void
    ){
        Auth.auth().createUser(withEmail: emailAddress, password: password) { result, error in
            guard let result = result , error == nil else {
                completion(false)
                return
            }
            DatabaseManager.shared.insertUser(with: emailAddress, username: username, completion: completion)
            
        }
    }
    
}
