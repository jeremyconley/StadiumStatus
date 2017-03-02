//
//  User.swift
//  Stadiums
//
//  Created by Jeremy Conley on 1/23/17.
//  Copyright © 2017 JeremyConley. All rights reserved.
//

import Foundation

struct User {
    var username: String
    var userId: String
    var email: String
    
    
    init(username: String, userId: String, email: String) {
        self.username = username
        self.userId = userId
        self.email = email
    }
    
    func toAnyObject() -> Any {
        return [
            "username": username,
            "userId": userId,
            "email": email
        ]
    }
}
