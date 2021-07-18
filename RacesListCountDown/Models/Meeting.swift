//
//  Meeting.swift
//  RacesCountDown
//
//  Created by Kohde Pitcher on 19/5/21.
//

import Foundation


/*
 *  Defines the model of the meeting which contains all the races for the meeting
 */
struct Meeting: Encodable, Decodable {
    
    var Races: [Race]
    
    init(races: [Race]) {
        Races = races
    }
    
}

extension Meeting {
    
    mutating func AddNewRace(from data: Race) {
        Races.append(data)
    }
    
}
