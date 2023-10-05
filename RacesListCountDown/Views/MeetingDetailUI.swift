//
//  MeetingDetailUI.swift
//  RacesListCountDown
//
//  Created by Kohde Pitcher on 31/12/21.
//

import SwiftUI

struct MeetingDetailUI: View {
    
    var MeetingKey: String
    var MeetingVenue: String
    var MeetingDate: Date
    
    @ObservedObject var viewModel = MeetingDetailViewModel()
    
    init(MeetingKey: String, MeetingVenue: String, MeetingDate: Date) {
        
        self.MeetingKey = MeetingKey
        self.MeetingVenue = MeetingVenue
        self.MeetingDate = MeetingDate
        
        viewModel.fetchMeetingRaces(meetingKey: MeetingKey)
    }
    
    var body: some View {
        
        //show list of races from the endpoint
        List {
            
            Section(header: Text("Races")) {
                
                //only show if the model data array is empty
                if viewModel.fetchedRaceList.Races.isEmpty {
                    HStack {

                        Image(systemName: "exclamationmark.triangle.fill")
                            .imageScale(.large)
                            .foregroundColor(.accentColor)
                            .padding(.trailing, 5)

                        VStack(alignment: .leading) {
                            Text("Oops, looks like there's no race times yet")
                            Spacer()
                            Text("Go back and find another meeting or check your internet connection")
                        }
                        .foregroundColor(Color.secondary)
                    }.padding(.vertical)
                }
                
                ForEach(viewModel.fetchedRaceList.Races, id: \.self) { item in
                    CountDownCell(with: item)
                }
            }
            
            Section() {
                
                Button(action: {
                    
                    viewModel.saveMeetingToCoreData(MeetingVenue: MeetingVenue, MeetingDate: MeetingDate)
                    //interactionDelegate?.dismissHostingController()
                    
                }) {
                    
                    HStack {
                        Image(systemName: "arrow.down.circle")
                        Text(viewModel.fetchedRaceList.Races.count > 0 ? "Save \(viewModel.fetchedRaceList.Races.count) Races" : "No Races To Save")
                    }
                    .foregroundColor(Color.accentColor)
                }
                .disabled(viewModel.fetchedRaceList.Races.isEmpty)
                
            }
            
            
            
            //No data message
            //Group {
                
                
            
            
        }
        .navigationTitle(MeetingVenue)
        
    }
}

struct MeetingDetailUI_Previews: PreviewProvider {
    static var previews: some View {
        MeetingDetailUI(MeetingKey: "", MeetingVenue: "Test", MeetingDate: Date())
    }
}
