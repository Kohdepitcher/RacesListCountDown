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
    
    /// Public observables
    @Published public var fetchedMeetingList: OrderedDictionary<Date, [MeetingOption]> = [:]
    @Published public var isLoading: Bool = false
    @Published public var selectedStateIndex = 0
    
    /// List of available states for the picker
    public let availableStates: [ViewValue] = [
        ViewValue(value: "QLD", viewValue: "Queensland"                     ),
        ViewValue(value: "NSW", viewValue: "New South Wales"                ),
        ViewValue(value: "VIC", viewValue: "Victoria"                       ),
        ViewValue(value: "ACT", viewValue: "Australian Capital Territory"   ),
        ViewValue(value: "NT",  viewValue: "Northern Territory"             ),
        ViewValue(value: "SA",  viewValue: "South Australia"                ),
        ViewValue(value: "WA",  viewValue: "Western Australia"              )
    ]
    
    
    /// Load some initial meetings when view is initialised
    init() {
        self.fetchMeetingsForSelectState()
    }
    
    public func fetchMeetingsForSelectState() {
        
        /// Show loading indicator
        self.isLoading = true
        
        /// Reset the meeting list
        self.fetchedMeetingList = [:]
        
        /// Setup the URL
        var components = URLComponents()
        components.scheme = "https"
        components.host = "m.racingaustralia.horse"
        components.path = "/FreeFields/Calendar.aspx"
        components.query = "State=" + availableStates[selectedStateIndex].value
        
        /// create a URL using the components
        let URL = components.url
        
        /// Try to fetch the meetings JSON from the server
        URLSession.shared.dataTask(with: URL!) { [self] data, response, error in
            
            if let data = data {
                
                do {
                    
                    /// Decode the data
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .formatted(DateFormatter.dayLongMonthYear)
                    
                    let response = try decoder.decode(MeetingList.self, from: data)
                    
                    DispatchQueue.main.async { [self] in
                        
                        /// Store the meeting list
                        let tempHolder: MeetingList = response
                        
                        /// Group meetings by meeting date
                        let groupedMeetings = OrderedDictionary<Date, [MeetingOption]>(grouping: tempHolder.Meetings, by: {$0.MeetDate })
                        
                        /// Store grouped meetings to be displayed in the UI
                        self.fetchedMeetingList = groupedMeetings
                        
                        /// Hide loading Indicator
                        isLoading = false
                    }
                    
                }
                catch let error {
                    print(error)
                    
                    /// Hide loading Indicator
                    isLoading = false
                }
            }
            
        }
        .resume()
        
    }
}
