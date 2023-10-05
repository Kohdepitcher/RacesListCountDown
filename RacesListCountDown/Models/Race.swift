//
//  Race.swift
//  RacesCountDown
//
//  Created by Kohde Pitcher on 19/5/21.
//

import Foundation

/*
 *  Defines the model for races contained within the Meeting Object
 */
struct Race: Encodable, Decodable, Hashable {
    
    //the number of the race
    var RaceNumber: String
    
    //title of the race
    var RaceTitle: String
    
    //what time the races are on
    var LocalStartTime: Date
    
    init(RaceNumber: String, RaceTitle: String, LocalStartTime: Date) {
        self.RaceNumber = RaceNumber
        self.RaceTitle = RaceTitle
        self.LocalStartTime = LocalStartTime
    }
    
}

extension Race {
    
    mutating func update(with data: Race) {
        RaceNumber = data.RaceNumber
        RaceTitle = data.RaceTitle
        LocalStartTime = data.LocalStartTime
    }
    
    
}
