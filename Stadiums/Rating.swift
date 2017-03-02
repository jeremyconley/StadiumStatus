//
//  Rating.swift
//  Stadiums
//
//  Created by Jeremy Conley on 1/23/17.
//  Copyright © 2017 JeremyConley. All rights reserved.
//

import Foundation

struct Rating {
    var user: String
    var stadium: String
    var rating: String
    var username: String
    var comment: String
    
    
    init(user: String, stadium: String, rating: String, username: String, comment: String) {
        self.user = user
        self.stadium = stadium
        self.rating = rating
        self.username = username
        self.comment = comment
    }
    
    func toAnyObject() -> Any {
        return [
            "user": user,
            "stadium": stadium,
            "rating": rating,
            "username": username,
            "comment": comment
        ]
    }

}
