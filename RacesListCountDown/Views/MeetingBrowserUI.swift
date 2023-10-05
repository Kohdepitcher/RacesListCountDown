//
//  MeetingBrowserUI.swift
//  RacesListCountDown
//
//  Created by Kohde Pitcher on 29/12/21.
//

import SwiftUI
import UIKit

//MARK: - Protocol for interacting between SwiftUI and UIKit
//this is responsible for delegating back up any interactions with the swiftui view to the settings hosting controller
protocol MettingBrowserVCInteractionDelegate {
    
}

//MARK: - Hosting View Controller Definition
//this is the hosting view controller to present this swiftui view within the UIKIT hierachy
class MeetingBrowserUIViewController: UIViewController, MettingBrowserVCInteractionDelegate {
    
    //create a hosting controller that has this settingsUI as its root view
    let contentView = UIHostingController(rootView: MeetingBrowserUI())
    
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
    
}


struct MeetingBrowserUI: View {
    
    var interactionDelegate: MettingBrowserVCInteractionDelegate?
    
    @ObservedObject var viewModel = MeetingBrowserViewModel()
    
    var body: some View {
        
        NavigationView {
            
            VStack(spacing: 0) {
//                SegmentedControlView(selectedIndex: $viewModel.selectedStateIndex, titles: viewModel.states)
//                    .onChange(of: viewModel.selectedStateIndex) {newValue in
//                        viewModel.fetchMeetingsForSelectState()
//                    }
                     //.background(Color.red)
                    //.frame(maxHeight: .infinity, alignment: .top)
                //HorizontalScrollingButtons(titles: ["Queensland", "New South Wales", "Victoria"])
                    //.frame(height: 40)
                
//                AKPickerRepresentable(items: viewModel.states, selectedIndex: $viewModel.selectedStateIndex)
//                    .onChange(of: viewModel.selectedStateIndex) {newValue in
//                        viewModel.fetchMeetingsForSelectState()
//                    }
//                    .frame(height: 40)
                
                    List {
                        
                        
                        
                        ForEach(viewModel.fetchedMeetingList.sorted(by: {$0.key < $1.key}), id: \.key) { key, value in
                            Section(header: Text(DateFormatter.dayLongMonthYear.string(from: key))) {
                                
                                ForEach(value, id:\.self) { meeting in
                                    
                                    NavigationLink(destination: MeetingDetailUI(MeetingKey: meeting.Key, MeetingVenue: meeting.MeetingVenue, MeetingDate: meeting.MeetDate)) {
                                        
                                        HStack {
                                            VStack(alignment: .leading) {
                                                Text(meeting.MeetingVenue)
                                                    .bold()
                                                Text(meeting.CurrentMeetingStage)
                                            }
                                            
                                            Spacer()
                                        }

                                    }
                                    //.disabled(meeting.CurrentMeetingStage != "FinalFields" || meeting.CurrentMeetingStage == "InterimResults")
                                    
                                }

                            }
                        }
                        
                    }
                    .listStyle(InsetGroupedListStyle())

            }//.onAppear(perform: {viewModel.fetchMeetingsForSelectState()})
                .navigationTitle("Meetings")
                .toolbar {
                            ToolbarItemGroup(placement: .bottomBar) {
                                AKPickerRepresentable(items: viewModel.states, selectedIndex: $viewModel.selectedStateIndex)
                                    .onChange(of: viewModel.selectedStateIndex) {newValue in
                                        viewModel.fetchMeetingsForSelectState()
                                    }
                                    .frame(height: 40)
                            }
                        }
        }
        
        
        
    }
}

struct MeetingBrowserUI_Previews: PreviewProvider {
    static var previews: some View {
        MeetingBrowserUI()
    }
}
