//
//  MeetingDetailViewModel.swift
//  RacesListCountDown
//
//  Created by Kohde Pitcher on 31/12/21.
//

import Foundation
import CoreData
import UIKit

class MeetingDetailViewModel: ObservableObject {
    
    @Published public var fetchedRaceList: Meeting = Meeting(races: [
    
//                Race(RaceNumber: "1", RaceTitle: "Carlton & United Breweries QTIS Two-Years-Old and Three-Years-Old Maiden Handicap (1300 METRES)", LocalStartTime: DateFormatter.HourMinuteFormatter.date(from: "1:42PM")!),
//                Race(RaceNumber: "2", RaceTitle: "2:17PM Great Northern Original BM65 Handicap (1600 METRES)", LocalStartTime: DateFormatter.HourMinuteFormatter.date(from: "2:17PM")!),
//                Race(RaceNumber: "3", RaceTitle: "Great Northern Crisp Class 6 Handicap (1300 METRES)", LocalStartTime: DateFormatter.HourMinuteFormatter.date(from: "2:57PM")!),
//                Race(RaceNumber: "4", RaceTitle: "The Real Group appreciation Maiden Handicap (1050 METRES)", LocalStartTime: DateFormatter.HourMinuteFormatter.date(from: "3:34PM")!),
//                Race(RaceNumber: "5", RaceTitle: "Pavscorp appreciation Class 3 Plate (1050 METRES)", LocalStartTime: DateFormatter.HourMinuteFormatter.date(from: "4:12PM")!),
//                Race(RaceNumber: "6", RaceTitle: "Book your Christmas Party BM58 Handicap (1200 METRES)", LocalStartTime: DateFormatter.HourMinuteFormatter.date(from: "4:52PM ")!),
    
    ])
    
//    public var MeetingDate: Date
//    public var MeetingVenue: String
    
//    init(MeetingDate: Date, MeetingVenue: String) {
//        self.MeetingVenue = MeetingVenue
//        self.MeetingVenue = MeetingVenue
//        self.fetchedRaceList = Meeting(races: [])
//    }
    
    public func fetchMeetingRaces(meetingKey: String) {
        
        //reset the modal array
        self.fetchedRaceList.Races = []
        
        //Setup the URL
        var components = URLComponents()
        components.scheme = "https"
        components.host = "m.racingaustralia.horse"
        components.path = "/FreeFields/Acceptances.aspx"
        components.query = "Key=" + meetingKey
        
        //create a URL using the components
        let url = components.url
        
        URLSession.shared.dataTask(with: url!) { data, response, error in
            
            if let data = data {
                
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .formatted(DateFormatter.HourMinuteFormatter)
                    
                    let response = try decoder.decode(Meeting.self, from: data)
                    
                    DispatchQueue.main.async {
                        self.fetchedRaceList = response
                    }
                    
                }
                catch let error {
                    print(error)
                }
            }
            
        }
        .resume()
        
    }
    
    /// Removes the previous saved meeting in Core Data
    private func removePreviousMeeting() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CDMeeting")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        
        do {
            try managedContext.execute(deleteRequest)
        } catch let error as NSError {
          debugPrint(error)
        }
        
    }
    
    /// Saves the selected meeting into Core Data
    public func saveMeetingToCoreData(MeetingVenue: String, MeetingDate: Date) {
        
        /// Delete the last save meeting
        removePreviousMeeting()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        /// Entity Descriptions
        guard let meetingEntity = NSEntityDescription.entity(forEntityName: "CDMeeting", in: managedContext) else {return}
        guard let raceEntity = NSEntityDescription.entity(forEntityName: "CDRace", in: managedContext) else {return}
        
        /// Create a new meeting and configure it
        let newMeetingEntity = CDMeeting(entity: meetingEntity, insertInto: managedContext)
        newMeetingEntity.meetingDate = MeetingDate
        newMeetingEntity.meetingLocation = MeetingVenue

        /// Iterate through all races
        for (index, item) in self.fetchedRaceList.Races.enumerated() {
            
            /// Create a new race
            let newRaceEntity = CDRace(entity: raceEntity, insertInto: managedContext)
            
            /// Build a date consisting of the meeting date and the local start time
            var calendar = Calendar(identifier: .gregorian)
            let components = DateComponents(year:   calendar.component(.year,   from: MeetingDate),
                                            month:  calendar.component(.month,  from: MeetingDate),
                                            day:    calendar.component(.day,    from: MeetingDate),
                                            hour:   calendar.component(.hour,   from: item.LocalStartTime),
                                            minute: calendar.component(.minute, from: item.LocalStartTime),
                                            second: 0)
            
            /// Configure the race entity
            newRaceEntity.raceUUID = UUID()
            newRaceEntity.raceTitle = item.RaceTitle
            newRaceEntity.raceNumber = item.RaceNumber
            newRaceEntity.localStartTime = calendar.date(from: components) //item.LocalStartTime
            newRaceEntity.order = Int16(index)
            
            /// Add the race to the meeting
            newRaceEntity.meeting = newMeetingEntity
            
            
        }
        
        /// try to save the meeting to Core Data
        do {
            try newMeetingEntity.managedObjectContext?.save()
        } catch {
            print("\(error), \(error.localizedDescription)")
        }
        
    }
    
}
