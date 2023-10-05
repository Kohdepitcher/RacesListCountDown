//
//  HorizontalScrollingButtons.swift
//  RacesListCountDown
//
//  Created by Kohde Pitcher on 17/2/2022.
//

import SwiftUI

struct HorizontalScrollingButtons: View {
    
//    @Binding private var selectedIndex: Int
    
    private let buttonTitles: [String]
    
    init(titles: [String]) {
        self.buttonTitles = titles
    }
    
    var body: some View {
        
        GeometryReader{ mainView in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(buttonTitles, id: \.self) { title in
                        GeometryReader { geometry in
                            HorizontalButton(title: title)
                                
                                .scaleEffect(scaleValue(mainFrame: mainView.frame(in: .global).minX, minX: geometry.frame(in: .global).minX), anchor: .center)
                        }.frame(width: 120, height: 50)
                    }
                }.padding()
            }

        }
    }
    
    private func scaleValue(mainFrame: CGFloat, minX: CGFloat) -> CGFloat {
        
        let scale = (minX - 15) / 15
        
        print(scale)

        if scale > 1 {
            return 1
        }
        
        else if scale < 0 {
            return 0
        }
        
        else {
            return scale
        }
//        print(scale)
        //print(scale)
        
//        return 1
        
    }
}

struct HorizontalButton: View {
    
    private var title: String
    
    init(title: String) {
        self.title = title
    }
    
    var body: some View {
        
        Text(title)
            .padding()
//            .padding([.leading, .trailing])
//            .padding([.top, .bottom], 10)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .foregroundColor(.red)
            )

        
    }
    
}

extension String {
    func sizeForString(usingFont font: Font) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        
        return size
    }
}

//struct HorizontalScrollingButtons_Previews: PreviewProvider {
//    static var previews: some View {
//        HorizontalScrollingButtons(titles: <#[String]#>)
//    }
//}
