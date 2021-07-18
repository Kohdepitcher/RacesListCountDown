//
//  MeetingCreator.swift
//  RacesCountDown
//
//  Created by Kohde Pitcher on 19/5/21.
//

import Foundation

class MeetingModel: ObservableObject {
    
    //properties
    //publisher that stores the meeting that is returned by the fetch qeury method down below
    @Published var meeting: Meeting = Meeting(races: [
        
        Race(RaceNumber: "1", RaceTitle: "QTIS Two-Year-Old Maiden Handicap (1100 METRES)", LocalStartTime: DateFormatter.HourMinuteFormatter.date(from: "12:42PM")!),
        Race(RaceNumber: "2", RaceTitle: "BENCHMARK 65 Handicap (1600 METRES)", LocalStartTime: DateFormatter.HourMinuteFormatter.date(from: "1:17PM")!),
        Race(RaceNumber: "3", RaceTitle: "Class 4 Handicap (1050 METRES)", LocalStartTime: DateFormatter.HourMinuteFormatter.date(from: "1:57PM")!),
        Race(RaceNumber: "4", RaceTitle: "Maiden Plate (1400 METRES)", LocalStartTime: DateFormatter.HourMinuteFormatter.date(from: "2:34PM")!),
        Race(RaceNumber: "5", RaceTitle: "QTIS Three-Year-Old Maiden Handicap (1200 METRES)", LocalStartTime: DateFormatter.HourMinuteFormatter.date(from: "3:12PM")!),
        Race(RaceNumber: "6", RaceTitle: "Class 1 Handicap (1200 METRES)", LocalStartTime: DateFormatter.HourMinuteFormatter.date(from: " 3:47PM ")!),
        Race(RaceNumber: "7", RaceTitle: "Class 6 Plate (1400 METRES)", LocalStartTime: DateFormatter.HourMinuteFormatter.date(from: "10:26PM")!)

    ])
    
    @Published var meetingDate: Date = Date()
    
    
    //This enum defines the towns that can be fetched
    enum towns: String, CaseIterable {
        case rockhampton = "Rockhampton"
        case yeppoon = "Yeppoon"
        case emerald = "Emerald"
    }
    
    func updateRemainingTime() {
        
//        self.meeting.Races.map {
//
//            var holder = $0
//            holder.updateTimeLeft()
//
//            //var index = meeting.Races.indexof
//
//            $0.updateTimeLeft()
//
//        }ß
        
        for index in 0..<meeting.Races.count {
            meeting.Races[index].updateTimeLeft()
        }
        
//        self.meeting.Races.enumerated().forEach({ (index, item) in
//            
//            item.updateTimeLeft()
//            
//        })
        
    }
    
    
    private func formateDateToURLInput(with date: Date) -> String {
        
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: date)
        let month = DateFormatter.monthMedium.string(from: date)
        let day = calendar.component(.day, from: date)
        
        return "\(year)\(month)\(day)"
        
    }
    
    func fetchMeetingRaces(with town: towns, date: Date) {
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "m.racingaustralia.horse"
        components.path = "/FreeFields/Acceptances.aspx"
        components.query = "Key=" + formateDateToURLInput(with: date) + ",QLD," + town.rawValue
        
        let url = components.url
        
        URLSession.shared.dataTask(with: url!) { data, response, error in
            
            if let data = data {
                
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .formatted(DateFormatter.HourMinuteFormatter)
                    
                    let response = try decoder.decode(Meeting.self, from: data)
                    
                    self.meeting = response
                    
//                    for race in response.Races {
//                        print(race)
//                    }
                    
                }
                catch let error {
                    print(error)
                }
            }
            
        }.resume()
        
    }
    
}
