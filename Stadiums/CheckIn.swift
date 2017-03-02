//
//  CheckIn.swift
//  Stadiums
//
//  Created by Jeremy Conley on 1/25/17.
//  Copyright © 2017 JeremyConley. All rights reserved.
//

import Foundation

struct CheckIn {
    var userId: String
    var stadiumId: String
    var checkInDate: String
    
    
    init(userId: String, stadiumId: String, checkInDate: String) {
        self.userId = userId
        self.stadiumId = stadiumId
        self.checkInDate = checkInDate
    }
    
    func toAnyObject() -> Any {
        return [
            "userId": userId,
            "stadiumId": stadiumId,
            "checkInDate": checkInDate
        ]
    }
}
