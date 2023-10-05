//
//  MeetingBrowserViewModel.swift
//  RacesListCountDown
//
//  Created by Kohde Pitcher on 29/12/21.
//

import Foundation
import OrderedCollections

struct MeetingList: Codable {
    let Meetings: [MeetingOption]
}

struct MeetingOption: Codable, Hashable {
    let MeetingVenue: String
    let MeetDate: Date
    let Key: String
    let CurrentMeetingStage: String
}

struct ViewValue {
    let value: String
    let viewValue: String
}

class MeetingBrowserViewModel: ObservableObject {
    
    
    
    @Published public var fetchedMeetingList: OrderedDictionary<Date, [MeetingOption]> = [:]//[String : [MeetingOption]] = ["": []]
    @Published public var isLoading: Bool = false
    
//    public let availableStates: [ViewValue] = [
//        ViewValue(value: "QLD", viewValue: "Queensland"),
//        ViewValue(value: "NSW", viewValue: "New South Wales"),
//        ViewValue(value: "VIC", viewValue: "Victoria"),
//        ViewValue(value: "ACT", viewValue: "Austalian Capital Territory")
//        ViewValue(value: "NT", viewValue: "Northern Teritory"),
//        ViewValue(value: "SA", viewValue: "South Australia"),
//        ViewValue(value: "WA", viewValue: "Western Australia")
//    ]
    
    public let states = ["QLD", "NSW", "VIC", "WA", "SA", "TAS", "NT", "ACT"]
    
    @Published public var selectedStateIndex = 0
    
    init() {
        self.fetchMeetingsForSelectState()
    }
    
    public func fetchMeetingsForSelectState() {
        
        //reset the meeting list
        self.fetchedMeetingList = [:]
        
        //Setup the URL
        var components = URLComponents()
        components.scheme = "https"
        components.host = "m.racingaustralia.horse"
        components.path = "/FreeFields/Calendar.aspx"
        components.query = "State=" + states[selectedStateIndex]
        
        //create a URL using the components
        let URL = components.url
        
        URLSession.shared.dataTask(with: URL!) { data, response, error in
            
            if let data = data {
                
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .formatted(DateFormatter.dayLongMonthYear)
                    
                    let response = try decoder.decode(MeetingList.self, from: data)
                    
                    DispatchQueue.main.async {
                        let tempHolder: MeetingList = response
                        
                        let groupedMeetings = OrderedDictionary<Date, [MeetingOption]>(grouping: tempHolder.Meetings, by: {$0.MeetDate })
                        
                        self.fetchedMeetingList = groupedMeetings
                    }
                    
                    
                    

                    
                }
                catch let error {
                    print(error)
                }
            }
            
        }
        .resume()
        
    }
}
