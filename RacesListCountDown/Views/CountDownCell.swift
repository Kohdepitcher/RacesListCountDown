//
//  CountDownCell.swift
//  RacesCountDown
//
//  Created by Kohde Pitcher on 21/5/21.
//

import SwiftUI
import Combine

struct CountDownCell: View {
    
    var race: Race
    
    init(with race: Race) {
        self.race = race
    }
    
    
    var body: some View {
        
        
            
            VStack(alignment: .leading) {
                
                Text("Race \(race.RaceNumber)")
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.leading)
                
                Text(DateFormatter.HourMinuteFormatter.string(from: race.LocalStartTime))
                
                Text(race.RaceTitle)
                    .fontWeight(.light)
                    .multilineTextAlignment(.leading)
                
            }.padding(.vertical)

        
        
        
    }
}

struct CountDownCell_Previews: PreviewProvider {
    static var previews: some View {
        CountDownCell(with: Race(RaceNumber: "1", RaceTitle: "Test", LocalStartTime: Date())).previewLayout(.sizeThatFits)
    }
}
