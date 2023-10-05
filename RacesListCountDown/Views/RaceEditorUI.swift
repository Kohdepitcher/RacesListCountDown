////
////  RaceEditorUI.swift
////  RacesListCountDown
////
////  Created by Kohde Pitcher on 5/9/21.
////
//
//import SwiftUI
//import UIKit
//
//import CoreData
//
////MARK: - Hosting View Controller Definition
////this is the hosting view controller to present this swiftui view within the UIKIT hierachy
//class RaceEditorUIViewController: UIViewController {
//    
//    public var context: NSManagedObjectContext!
//    public var raceObjectID: NSManagedObjectID!
//    
//    
//    override func viewDidLoad() {
//        
//        //create a hosting controller that has this SwiftUI Screen as its root view
//        let contentView = UIHostingController(rootView: RaceEditorUI(id: raceObjectID)
//        
//                                                .environment(\.managedObjectContext, context)
//        
//        )
//        
//        //add the subview and children to the view controller
//        addChild(contentView)
//        view.addSubview(contentView.view)
//        
////        contentView.rootView.settingsDelegate = self
//        
//        //setup constraints
//        contentView.view.translatesAutoresizingMaskIntoConstraints = false;
//        contentView.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        contentView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//        contentView.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
//        contentView.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
//        
//    }
//    
//}
//
//struct RaceEditorUI: View {
//    
//    @ObservedObject var race: CDRace!
//    
//    
//    @Environment(\.managedObjectContext) private var context
//    
//    init(id: NSManagedObjectID) {
//        if let race = try? context.existingObject(with: id) as? CDRace {
//            self.race = race
//        } else {
//            fatalError("Can't find object for NSManagedObjectID")
//        }
//    }
//    
//    var body: some View {
//        
//        NavigationView {
//            
//            ZStack {
//                
//                Color("Background Color").ignoresSafeArea()
//                
//                VStack(spacing: 0) {
//                    
//                    Group {
//                        VStack(alignment: .leading) {
//                            
//                            HStack {
//                                Text("\(race.raceNumber!)")
//                                    .font(.system(size: 17, weight: .semibold, design: .default))
//                                
//                                Spacer()
//                                Text("Done")
//                                    .font(.system(size: 17, weight: .semibold, design: .default))
//                            }
//                            
//                            Text("01:27PM")
//                                .font(.system(size: 17, weight: .regular, design: .default))
//                            
//                            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//                                .font(.system(size: 17, weight: .light, design: .default))
//                            
//                        }
//                        
//                        .padding(.all, 15)
//                    }
//                    .background(Color.white)
//                    .mask(RoundedRectangle(cornerRadius: 12))
//                    .padding()
//                    
//                    
//                    Divider()
//                    
//                    ScrollView() {
//                        
//                        VStack {
//                            
//                            Group {
//                                VStack(alignment: .leading) {
//                                    
//                                    HStack {
//                                        Text("Race 1")
//                                            .font(.system(size: 17, weight: .semibold, design: .default))
//                                        
//                                        Spacer()
//                                        Text("Done")
//                                            .font(.system(size: 17, weight: .semibold, design: .default))
//                                    }
//                                    
//                                    Text("01:27PM")
//                                        .font(.system(size: 17, weight: .regular, design: .default))
//                                    
//                                    Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//                                        .font(.system(size: 17, weight: .light, design: .default))
//                                    
//                                }
//                                .padding(.all, 15)
//                            }
//
//                            
//                        }
//                        
//                    }
//                    
//                }
//                
//                
//                
//                
//                
//            }
//            
//            .navigationBarTitle("", displayMode: .inline)
//            
//            .toolbar {
//                ToolbarItem(placement: .cancellationAction) {
//                                    Button("Cancel") {
//                                        print("Help tapped!")
//                                    }
//                                }
//                
//                ToolbarItem(placement: .confirmationAction) {
//                                    Button("Done") {
//                                        print("Help tapped!")
//                                    }
//                                }
//                            }
//            
//        }
//        
//        
//    }
//}
//
////struct RaceEditorUI_Previews: PreviewProvider {
////    static var previews: some View {
////        RaceEditorUI(id: <#NSManagedObjectID#>)
////    }
////}
