//
//  MeetingCreator.swift
//  RacesCountDown
//
//  Created by Kohde Pitcher on 19/5/21.
//

import Foundation
import CoreData
import UIKit

//This enum defines the towns that can be fetched
enum towns: String, CaseIterable, Equatable, Identifiable, Hashable {
    
    var id: towns {self}
    
    case rockhampton = "Rockhampton"
    case yeppoon = "Yeppoon"
    case emerald = "Emerald"
    case Moranbah = "Moranbah"
}

class MeetingModel: ObservableObject {
    
    //properties
    //publisher that stores the meeting that is returned by the fetch qeury method down below
    @Published public var meeting: Meeting = Meeting(races: [
        
//        Race(RaceNumber: "1", RaceTitle: "Carlton & United Breweries QTIS Two-Years-Old and Three-Years-Old Maiden Handicap (1300 METRES)", LocalStartTime: DateFormatter.HourMinuteFormatter.date(from: "1:42PM")!),
//        Race(RaceNumber: "2", RaceTitle: "2:17PM Great Northern Original BM65 Handicap (1600 METRES)", LocalStartTime: DateFormatter.HourMinuteFormatter.date(from: "2:17PM")!),
//        Race(RaceNumber: "3", RaceTitle: "Great Northern Crisp Class 6 Handicap (1300 METRES)", LocalStartTime: DateFormatter.HourMinuteFormatter.date(from: "2:57PM")!),
//        Race(RaceNumber: "4", RaceTitle: "The Real Group appreciation Maiden Handicap (1050 METRES)", LocalStartTime: DateFormatter.HourMinuteFormatter.date(from: "3:34PM")!),
//        Race(RaceNumber: "5", RaceTitle: "Pavscorp appreciation Class 3 Plate (1050 METRES)", LocalStartTime: DateFormatter.HourMinuteFormatter.date(from: "4:12PM")!),
//        Race(RaceNumber: "6", RaceTitle: "Book your Christmas Party BM58 Handicap (1200 METRES)", LocalStartTime: DateFormatter.HourMinuteFormatter.date(from: "4:52PM ")!),


    ])
    
    //Tracks the date for the meeting to be fetched
    @Published public var meetingDate: Date = Date()
    
    //Tracks the town for the meeting to be fetched
    @Published public var meetingLocation: towns = towns.allCases.first!
    
    //Tracks if the meeting to be fetched is for trials
    @Published public var isTrialMeeting: Bool = false
    
    @Published public var isLoading: Bool = false
    
    
    /*
     *  This func is responsible for formatting an inputed date to a string representation that is accepted by the HTTP endpoint
     *
     *  Input: Date
     *  Output: String - in format of yyyymmmdd e.g. 2021Jul25
     */
    private func formateDateToURLInput(with date: Date) -> String {
        
        //reference to the current calendar
        let calendar = Calendar.current
        
        //get year component from the date input
        let year = calendar.component(.year, from: date)
        
        //get the month component from the date input formatted by the medium month formatter
        let month = DateFormatter.monthMedium.string(from: date)
        
        //get the day component from the date input
        let day = calendar.component(.day, from: date)
        
        //return an concatenated string representing the input date for the API
        return "\(year)\(month)\(day > 9 ? "\(day)" : "0\(day)")"
        
    }
    
    
    /*
     *  This func is responsible for fetching the JSON from the endpoint using the filter properties above
     *  It will then convert the JSON into matching Meeting and Race objects
     */
    public func fetchMeetingRaces() {
        
        //reset the modal array
        self.meeting.Races = []
        
        //Setup the URL
        var components = URLComponents()
        components.scheme = "https"
        components.host = "m.racingaustralia.horse"
        components.path = "/FreeFields/Acceptances.aspx"
        components.query = "Key=" + formateDateToURLInput(with: meetingDate) + ",QLD," + meetingLocation.rawValue + (isTrialMeeting == true ? ",Trial" : "")
        
        //create a URL using the components
        let url = components.url
        
        print("URL: \(url?.absoluteString)")
        
        URLSession.shared.dataTask(with: url!) { data, response, error in
            
            if let data = data {
                
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .formatted(DateFormatter.HourMinuteFormatter)
                    
                    let response = try decoder.decode(Meeting.self, from: data)
                    
                    DispatchQueue.main.async {
                        self.meeting = response
                    }
                    
                    
                    
//                    for race in response.Races {
//                        print(race)
//                    }
                    
                }
                catch let error {
                    print(error)
                }
            }
            
        }
        .resume()
        
    }
    
    public func removePreviousMeeting() {
        
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
    
    public func saveMeetingToCoreData() {
        
        removePreviousMeeting()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //Entity Descriptions
        guard let meetingEntity = NSEntityDescription.entity(forEntityName: "CDMeeting", in: managedContext) else {return}
        guard let raceEntity = NSEntityDescription.entity(forEntityName: "CDRace", in: managedContext) else {return}
        
        let newMeetingEntity = CDMeeting(entity: meetingEntity, insertInto: managedContext)
        newMeetingEntity.meetingDate = self.meetingDate
        newMeetingEntity.meetingLocation = self.meetingLocation.rawValue

        
        for (index, item) in self.meeting.Races.enumerated() {
            let newRaceEntity = CDRace(entity: raceEntity, insertInto: managedContext)
            
            newRaceEntity.raceUUID = UUID()
            newRaceEntity.raceTitle = item.RaceTitle
            newRaceEntity.raceNumber = item.RaceNumber
            newRaceEntity.localStartTime = item.LocalStartTime
            newRaceEntity.order = Int16(index)
            
            newRaceEntity.meeting = newMeetingEntity
            
            
        }
        
        do {
            try newMeetingEntity.managedObjectContext?.save()
        } catch {
            print("\(error), \(error.localizedDescription)")
        }
        
    }
    
}
