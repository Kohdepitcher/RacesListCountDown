//
//  RaceDataFetcherUI.swift
//  RacesListCountDown
//
//  Created by Kohde Pitcher on 18/7/21.
//

import SwiftUI
import UIKit

//MARK: - Protocol for interacting between SwiftUI and UIKit
//this is responsible for delegating back up any interactions with the swiftui view to the settings hosting controller
protocol RaceDataFetcherVCInteractionDelegate {
    func dismissHostingController()
}

//MARK: - Hosting View Controller Definition
//this is the hosting view controller to present this swiftui view within the UIKIT hierachy
class RaceDataFetcherUIViewController: UIViewController, RaceDataFetcherVCInteractionDelegate {
    
    //create a hosting controller that has this settingsUI as its root view
    let contentView = UIHostingController(rootView: RaceDataFetcherUI())
    
    override func viewDidLoad() {
        
        //add the subview and children to the view controller
        addChild(contentView)
        view.addSubview(contentView.view)
        
        contentView.rootView.interactionDelegate = self
        
        //setup constraints
        contentView.view.translatesAutoresizingMaskIntoConstraints = false;
        contentView.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        contentView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        contentView.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        contentView.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
    }
    
    func dismissHostingController() {
        self.dismiss(animated: true, completion: nil)
    }
    
}


//MARK: - Race Data Fetcher SwiftUI View
struct RaceDataFetcherUI: View {
    
    var interactionDelegate: RaceDataFetcherVCInteractionDelegate?
    
    @ObservedObject var modal = MeetingModel()
    
    @State var meetingDate: Date = Date()
    @State var meetingLocation: towns = towns.rockhampton
    
    var body: some View {
        
        NavigationView {
            Form {
                
                //Filters section
                Section(header: Text("Meeting Filter")) {

                    //meeting date picker
                    DatePicker("Date", selection: $modal.meetingDate, displayedComponents: .date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                    
                    //meeting location picker
                    Picker(selection: $modal.meetingLocation, label: Text("Town")) {
                        ForEach(towns.allCases) { town in
                            Text(town.rawValue)
                        }
                    }
                    
                    //meeting is trials toggle
                    Toggle("Trials", isOn: $modal.isTrialMeeting)
                }
                
                //Download button section
                Section {
                    Button(action: {
                        
                        //fetch the meeting using the set filters
                        modal.fetchMeetingRaces()
                        
                    }) {
                        HStack {
                            Image(systemName: "arrow.down")
                            Text("Fetch Races")
                        }
                    }
                }
                
                //only show this section if the races count is above 0
                //if modal.meeting.Races.count > 0 {
                    Section(header: Text("Races")) {
                        
                        //show list of races from the endpoint
                        List {
                            ForEach(modal.meeting.Races, id: \.self) { item in
                                CountDownCell(with: item)
                            }
                            
                            //No data message
                            //Group {
                                
                                //only show if the model data array is empty
                                if modal.meeting.Races.isEmpty {
                                    HStack {
                                        
                                        Image(systemName: "exclamationmark.triangle.fill")
                                            .imageScale(.large)
                                            .foregroundColor(.accentColor)
                                            .padding(.trailing, 5)
                                        
                                        VStack(alignment: .leading) {
                                            Text("Oops, loos like there's no data...")
                                            Text("Check your filter and try again")
                                        }
                                        .foregroundColor(Color.secondary)
                                    }.padding(.vertical)
                                }
                            //}
                            
                        }
                    }
                //}
                
            }
            
            .navigationTitle(Text("Download Races"))
        }
        
        //overlay for the save races overlay button
        .overlay(
            
            Button(action: {
                
                modal.saveMeetingToCoreData()
                interactionDelegate?.dismissHostingController()
                
            }) {

                Text(modal.meeting.Races.count > 0 ? "Save \(modal.meeting.Races.count) Races" : "No Races To Save")
                        .padding(.vertical, 6)
                        .padding(.horizontal, 36.0)
            }
            .cornerRadius(10)
            .disabled(modal.meeting.Races.count == 0)
            .buttonStyle(SquarcleSolidButtonStyle(foreground: Color.white, background: Color.accentColor))
            

        
            , alignment: .bottom)
        
        
        
        
    }
}

struct RaceDataFetcherUI_Previews: PreviewProvider {
    static var previews: some View {
        RaceDataFetcherUI()
    }
}
