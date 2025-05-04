//
//  SwiftUIView.swift
//  SwiftLens
//
//  Created by Karin Prater on 04/05/2025.
//

import SwiftUI

struct DemoFullScreenCoverView: View {
    
    @State private var fullScreenCoverIsShown = false
    @State private var isFavorite = false
    
    var body: some View {
        VStack(spacing: 20) {
            Button("Show Presentation") {
                fullScreenCoverIsShown.toggle()
            }
            .trackButton(accessibilityIdentifier: "ShowPresentationButton")
            
            Text("Demo View")
                .preferenceTracking(identifier: "Demo.View.Text", viewName: "DemoSheetView")
        }
        .trackingFullScreenCover(isPresented: $fullScreenCoverIsShown, content: {
            DemoSheetContentView(isFavorite: $isFavorite)
        })
    }
}

struct DemoFullScreenCoverItemView: View {
    
    @State private var selectedItem: FoodCategory? = nil
    @State private var isFavorite = false
    
    var body: some View {
        VStack(spacing: 20) {
            Button("Show Details") {
                selectedItem = .american
            }
            .trackButton(accessibilityIdentifier: "ShowPresentationButton")
            
            Text("Demo View")
                .preferenceTracking(identifier: "Demo.View.Text", viewName: "DemoSheetView")
        }
        .trackingFullScreenCover(item: $selectedItem, content: { _ in
            DemoSheetContentView(isFavorite: $isFavorite)
        })
    }
}
