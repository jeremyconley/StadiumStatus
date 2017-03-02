//
//  Stadium.swift
//  Stadiums
//
//  Created by Jeremy Conley on 11/18/16.
//  Copyright © 2016 JeremyConley. All rights reserved.
//

import Foundation

struct Stadium {
    var name: String
    var team: String
    var type: String
    var conference: String
    var division: String
    var location: String
    var teampicDownloadURL: String
    var stadiumpicDownloadURL: String
    
    init(name: String, team: String, type: String, conference: String, division: String, location: String, teampicDownloadURL: String, stadiumpicDownloadURL: String){
        self.name = name
        self.team = team
        self.type = type
        self.conference = conference
        self.division = division
        self.location = location
        self.teampicDownloadURL = teampicDownloadURL
        self.stadiumpicDownloadURL = stadiumpicDownloadURL
    }
    
    func toAnyObject() -> Any {
        return [
            "name": name,
            "team": team,
            "type": type,
            "conference": conference,
            "division": division,
            "location": location,
            "teampicDownloadURL": teampicDownloadURL,
            "stadiumpicDownloadURL": stadiumpicDownloadURL
        ]
    }
}
