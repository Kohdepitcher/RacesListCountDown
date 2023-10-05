//
//  AKPickerRepresentable.swift
//  RacesListCountDown
//
//  Created by Kohde Pitcher on 19/2/2022.
//

import SwiftUI

struct AKPickerRepresentable: UIViewRepresentable {
    
    var items: [String]
    @Binding var selectedIndex: Int
    
    func makeUIView(context: Context) -> some UIView {
        let picker = AKPickerView()
        
        //setup the picker
        picker.pickerViewStyle = .flat
        picker.highlightedTextColor = UIColor(Color.accentColor)
        picker.interitemSpacing = 20
        picker.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        picker.highlightedFont = UIFont.systemFont(ofSize: 17, weight: .regular)
        
        //set delegate and datasource for the picker
        picker.delegate = context.coordinator
        picker.dataSource = context.coordinator
        
        //select the first item
        picker.selectItem(0)
        
        return picker
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, AKPickerViewDataSource, AKPickerViewDelegate {
        
        var parent: AKPickerRepresentable
        
        init(_ parent: AKPickerRepresentable) {
            self.parent = parent
        }
        
        func numberOfItemsInPickerView(_ pickerView: AKPickerView) -> Int {
            parent.items.count
        }
        
        func pickerView(_ pickerView: AKPickerView, titleForItem item: Int) -> String {
            return parent.items[item]
        }
        
        func pickerView(_ pickerView: AKPickerView, didSelectItem item: Int) {
            self.parent.selectedIndex = item
        }
        
    }
}

