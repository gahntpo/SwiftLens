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
            .lensButton(id: "ShowPresentationButton")
            
            Text("Demo View")
                .lensTracked(id: "Demo.View.Text")
        }
        .lensFullScreenCover(id: "fullscreencover.content.group",
                             isPresented: $fullScreenCoverIsShown,
                             content: {
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
            .lensButton(id: "ShowPresentationButton")
            
            Text("Demo View")
                .lensTracked(id: "Demo.View.Text")
        }
        .lensFullScreenCover(id: "fullscreencover.content.group",
                             item: $selectedItem,
                             content: { _ in
            DemoSheetContentView(isFavorite: $isFavorite)
        })
    }
}
