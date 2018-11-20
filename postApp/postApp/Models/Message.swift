//
//  Message.swift
//  postApp
//
//  Created by Vasyl Yavorskyy on 19/04/2018.
//  Copyright © 2018 Vasyl Yavorskyy. All rights reserved.
//

import Foundation

class Message {
    var autor: UserProfile
    var mId: String
    var text: String
    var timestamp: Double
    var isSender: Bool
    
    init(autor: UserProfile, mId: String, text: String, timestamp: Double, isSender: Bool) {
        self.autor = autor
        self.mId = mId
        self.text = text
        self.timestamp = timestamp
        self.isSender = isSender
    }
}
