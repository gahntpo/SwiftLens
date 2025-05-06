//
//  SwiftUIView.swift
//  SwiftLens
//
//  Created by Karin Prater on 29/04/2025.
//

import SwiftUI

enum FoodCategory: String, CaseIterable, Identifiable {
    case italian = "Italian"
    case mexican = "Mexican"
    case chinese = "Chinese"
    case indian = "Indian"
    case american = "American"
    var id: FoodCategory { self }
}

struct DemoPickerView: View {
    
    @State private var selectedCategory = FoodCategory.american
    @State private var selectedDate = Date()
    
    var body: some View {
        VStack {
            Picker("Food Category",
                   selection: $selectedCategory) {
                ForEach(FoodCategory.allCases) {
                    Text($0.rawValue)
                }
            }
             .lensPicker(id: "demo_picker",
                          selection: $selectedCategory)
            
            DatePicker("date", selection: $selectedDate)
                .lensPicker(id: "demo_date_picker",
                            selection: $selectedDate)
        }
    }
}

