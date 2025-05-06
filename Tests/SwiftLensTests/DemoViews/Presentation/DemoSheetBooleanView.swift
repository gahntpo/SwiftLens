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
            .lensButton(id: "ShowDetailsButton")
            
            Text("Demo View")
                .lensTracked(id: "Demo.View.Text")
        }
        .lensSheet(id: "sheet.content.group",
                   isPresented: $showDetails, content: {
            DemoSheetContentView(isFavorite: $isFavorite)
        })
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
            .lensButton(id: "ShowDetailsButton")
            .lensSheet(id: "sheet.content.group",
                       isPresented: $showDetails, content: {
                DemoSheetContentView(isFavorite: $isFavorite)
            })
            
            Text("Demo View")
                .lensTracked(id:  "Demo.View.Text")
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
            .lensButton(id: "ShowDetailsButton")
            
            Text("Testing Text")
                .lensSheet(id: "sheet.content.group",
                           isPresented: $showDetails, content: {
                    DemoSheetContentView(isFavorite: $isFavorite)
                })
            
            Text("Demo View")
                .lensTracked(id: "Demo.View.Text")
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
                .lensTracked(id: "FavoriteText",
                             info: ["isFavorite": isFavorite]
                )
            
            Button("Mark Favorite") {
                isFavorite = true
            }
            .lensButton(id: "FavoriteButton")
        
            
            // 2) A “Close” button to dismiss the sheet
            Button("Close") {
                dismiss()
            }
            .lensButton(id: "CloseSheetButton")
        }
        .padding()
    }
}


