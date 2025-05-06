//
//  SwiftUIView.swift
//  SwiftLens
//
//  Created by Karin Prater on 02/05/2025.
//

import SwiftUI

struct DemoSheetBooleanView: View {
    
    @State private var showDetails = false
    @State private var isFavorite = false
    
    var body: some View {
        VStack(spacing: 20) {
            Button("Show Details") {
                showDetails.toggle()
            }
            .trackButton(accessibilityIdentifier: "ShowDetailsButton")
            
            Text("Demo View")
                .preferenceTracking(identifier: "Demo.View.Text", viewName: "DemoSheetView")
        }
        .trackingSheet(isPresented: $showDetails) {
            DemoSheetContentView(isFavorite: $isFavorite)
        }
    }
}

struct DemoSheetTwoView: View {
    
    @State private var showDetails = false
    @State private var isFavorite = false
    
    var body: some View {
        VStack(spacing: 20) {
            Button("Show Details") {
                showDetails.toggle()
            }
            .trackButton(accessibilityIdentifier: "ShowDetailsButton")
            .trackingSheet(isPresented: $showDetails) {
                DemoSheetContentView(isFavorite: $isFavorite)
            }
            
            Text("Demo View")
                .preferenceTracking(identifier: "Demo.View.Text", viewName: "DemoSheetView")
        }
    }
}

struct DemoSheetThreeView: View {
    
    @State private var showDetails = false
    @State private var isFavorite = false
    
    var body: some View {
        VStack(spacing: 20) {
            Button("Show Details") {
                showDetails.toggle()
            }
            .trackButton(accessibilityIdentifier: "ShowDetailsButton")
            
            Text("Testing Text")
            .trackingSheet(isPresented: $showDetails) {
                DemoSheetContentView(isFavorite: $isFavorite)
            }
            
            Text("Demo View")
                .preferenceTracking(identifier: "Demo.View.Text", viewName: "DemoSheetView")
        }
    }
}

struct DemoSheetContentView: View {
    
    @Binding var isFavorite: Bool
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 16) {
            // 1) A “Mark Favorite” button that disables itself once tapped
            Text("isFavorite \(isFavorite ? "true" : "false")")
                .preferenceTracking(
                    identifier: "FavoriteText",
                    viewName: "DemoSheetContentView",
                    info: ["isFavorite": isFavorite]
                )
            
            Button("Mark Favorite") {
                isFavorite = true
            }
            .trackButton(accessibilityIdentifier: "FavoriteButton")
        
            
            // 2) A “Close” button to dismiss the sheet
            Button("Close") {
                dismiss()
            }
            .trackButton(accessibilityIdentifier: "CloseSheetButton")
        }
        .padding()
    }
}


