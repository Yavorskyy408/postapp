//
//  UserProfile.swift
//  loginApp
//
//  Created by Vasyl Yavorskyy on 14.03.18.
//  Copyright © 2018 Vasyl Yavorskyy. All rights reserved.
//

import Foundation

class UserProfile {
    var uId: String
    var name: String
    var surname: String
    var photoURL: URL
    
    init(uId: String, name: String, surname: String, photoURL: URL) {
        self.uId = uId
        self.name = name
        self.surname = surname
        self.photoURL = photoURL
    }
}
