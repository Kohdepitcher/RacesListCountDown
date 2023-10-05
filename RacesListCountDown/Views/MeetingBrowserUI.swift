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
protocol MeetingBrowserVCInteractionDelegate {
    
}

//MARK: - Hosting View Controller Definition
//this is the hosting view controller to present this swiftui view within the UIKIT hierachy
class MeetingBrowserUIViewController: UIViewController, MeetingBrowserVCInteractionDelegate {
    
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
    
    var interactionDelegate: MeetingBrowserVCInteractionDelegate?
    
    @ObservedObject var viewModel = MeetingBrowserViewModel()
    
    var body: some View {
        
        NavigationView {
            
            VStack(spacing: 0) {
                
                    List {
                        
                        /// State picker
                        Picker("Choose State", selection: $viewModel.selectedStateIndex) {
                            ForEach(viewModel.availableStates.indices, id: \.self) { index in
                                Text(viewModel.availableStates[index].viewValue)
                                    .tag(index)
                            }
                        }
                        .pickerStyle(.menu)
                        
                        /// Fetch meetings for the currently selected state
                        .onChange(of: viewModel.selectedStateIndex) { _ in
                            viewModel.fetchMeetingsForSelectState()
                        }
                        
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
        }
        
        /// Loading overlay
        .overlay {
            if viewModel.isLoading {
                HStack(spacing: 10) {
                    ProgressView()
                    Text("Loading")
                }
                    .animation(.easeInOut, value: viewModel.isLoading)
            }
        }
        
        
    }
}

struct MeetingBrowserUI_Previews: PreviewProvider {
    static var previews: some View {
        MeetingBrowserUI()
    }
}
