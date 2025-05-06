//
//  SwiftUIView.swift
//  SwiftLens
//
//  Created by Karin Prater on 02/05/2025.
//

import SwiftUI

struct DemoSheetItemView: View {
    
    @State private var selectedItem: FoodCategory? = nil
    @State private var isFavorite = false
    
    var body: some View {
        VStack(spacing: 20) {
            Button("Show Details") {
                selectedItem = .american
            }
            .lensButton(id: "ShowDetailsButton")
            
            Text("Demo View")
                .lensTracked(id: "Demo.View.Text")
        }
        .lensSheet(id: "sheet.content.group",
                   item: $selectedItem,
                   content: { item in
            DemoSheetContentView(isFavorite: $isFavorite)
        })
    }
}

struct DemoSheetItemTwoView: View {
    
    @State private var selectedItem: FoodCategory? = nil
    @State private var isFavorite = false
    
    var body: some View {
        VStack(spacing: 20) {
            Button("Show Details") {
                selectedItem = .american
            }
            .lensButton(id: "ShowDetailsButton")
            .lensSheet(id: "sheet.content.group",
                       item: $selectedItem,
                       content: { item in
                DemoSheetContentView(isFavorite: $isFavorite)
            })
            
            Text("Demo View")
                .lensTracked(id: "Demo.View.Text")
        }

    }
}

struct DemoSheetItemThreeView: View {
    
    @State private var selectedItem: FoodCategory? = nil
    @State private var isFavorite = false
    
    var body: some View {
        VStack(spacing: 20) {
            Button("Show Details") {
                selectedItem = .american
            }
            .lensButton(id: "ShowDetailsButton")
            
            Text("Testing Text")
                .lensSheet(id: "sheet.content.group",
                           item: $selectedItem,
                           content: { item in
                    DemoSheetContentView(isFavorite: $isFavorite)
                })
            
            Text("Demo View")
                .lensTracked(id: "Demo.View.Text")
        }
    }
}
