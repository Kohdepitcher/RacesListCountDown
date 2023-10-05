//
//  Custom SwiftUI View Styles.swift
//  RacesListCountDown
//
//  Created by Kohde Pitcher on 19/7/21.
//

import Foundation
import SwiftUI

struct SquarcleTranslucentButtonStyle: ButtonStyle {
    
    let color: Color
    let height: CGFloat
    let width: CGFloat
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(color)
            .frame(width: width, height: height)
            .background(color.opacity(0.30))
            .cornerRadius(10)
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
    }
}

struct SquarcleSolidButtonStyle: ButtonStyle {
    
    var foreground = Color.white
    var background = Color.blue
        
    func makeBody(configuration: ButtonStyle.Configuration) -> some View {
        MyButton(foreground: foreground, background: background, configuration: configuration)
    }

    struct MyButton: View {
        var foreground:Color
        var background:Color
        let configuration: ButtonStyle.Configuration
        @Environment(\.isEnabled) private var isEnabled: Bool
        var body: some View {
            configuration.label
                .cornerRadius(10)
                .padding(EdgeInsets(top: 7.0, leading: 7.0, bottom: 7.0, trailing: 7.0))
//                .frame(maxWidth: .infinity)
                
                .foregroundColor(isEnabled ? foreground : foreground.opacity(0.9))
                .background(isEnabled ? background : background.opacity(0.9))
                .opacity(configuration.isPressed ? 0.8 : 1.0)
        }
    }
    
//    let color: Color
//
//    func makeBody(configuration: Self.Configuration) -> some View {
//        configuration.label
//            .foregroundColor(Color.white)
//            .background(configuration.isPressed ? color.opacity(0.8) : color)
//            .cornerRadius(10)
//    }
}
