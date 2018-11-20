//
//  Post.swift
//  loginApp
//
//  Created by Vasyl Yavorskyy on 12.03.18.
//  Copyright © 2018 Vasyl Yavorskyy. All rights reserved.
//

import Foundation
import Firebase

class Post {
    
    var ref: DatabaseReference
    var id: String
    var author: UserProfile
    var text: String
    var timestamp: Double
    
    init(ref: DatabaseReference, id: String, author: UserProfile, text: String, timestamp: Double) {
        self.ref = ref
        self.id = id
        self.author = author
        self.text = text
        self.timestamp = timestamp
    }
}
