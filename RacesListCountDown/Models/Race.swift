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
    
    var remainingTime: String = ""
    
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
    
    public mutating func updateTimeLeft() {
        
        let currentDate = Date()
        print("currentDate: \(currentDate)")
        print("startTime: \(self.LocalStartTime)")
        
        let delta = Calendar.current.dateComponents([.second], from: currentDate, to: self.LocalStartTime)
        //currentDate.distance(to: race.LocalStartTime)
        
        let deltaAsSeconds = delta.second
        
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        
        
        
        if deltaAsSeconds! <= 0 {
            self.remainingTime = "Done"
        } else {
            self.remainingTime = formatter.string(from: delta)!
        }
        
    }
    
}
