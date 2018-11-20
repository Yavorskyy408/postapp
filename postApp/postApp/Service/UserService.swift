//
//  UserService.swift
//  loginApp
//
//  Created by Vasyl Yavorskyy on 14.03.18.
//  Copyright © 2018 Vasyl Yavorskyy. All rights reserved.
//

import Foundation
import Firebase

class UserService {
    /// set user who is login
    static var currentUserProfile: UserProfile?
    
    static func observeUserProfile(_ uId: String, completion: @escaping (_ userProfile: UserProfile?)->()) {
    
        let userRef = Database.database().reference().child("users/profile/\(uId)")
        
        userRef.observe(.value, with: { snapshot in
            var userProfile: UserProfile?
            
            if let dict = snapshot.value as? [String: Any],
                let userName = dict["userName"] as? String,
                let userSurname = dict["userSurname"] as? String,
                let photoURL = dict["photoURL"] as? String,
                let url = URL(string: photoURL) {
                
                userProfile = UserProfile(uId: uId, name: userName, surname: userSurname, photoURL: url)
            }
            completion(userProfile)
        })
    }
}
