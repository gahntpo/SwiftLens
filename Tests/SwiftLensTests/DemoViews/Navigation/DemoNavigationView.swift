//
//  NavigationExampleView.swift
//  UserInteractionSimulationProject
//
//  Created by Karin Prater on 03/05/2025.
//

import SwiftUI

@available(iOS 16.0, *)
struct DemoNavigationView: View {
    
    @ObservedObject var fetcher: CategoryFetcher
    let containerStyle: DemoListView.ContainerStyle
    let rowContentStyle: CategoryRow.ContentStyle
    
    var body: some View {
        
        if #available(iOS 16.0, *) {
            NavigationStack {
                DemoListView(fetcher: fetcher,
                             containerStyle: containerStyle,
                             rowContentStyle: rowContentStyle)
                .navigationDestination(for: Category.self) { category in
                    CategoryDetailView(category: category)
                }
            }
        } else {
            NavigationView {
                Text("TODO")
            }
        }
    }
}

struct CategoryDetailView: View {
    let category: Category
    var body: some View {
        VStack {
            Text("Detail")
            Text(category.title)
        }
        .preferenceTracking(identifier: "detail.category.\(category.id)",
                            viewName: "DetailView")
        .onAppear {
            print("--> detail appear for \(category.title)")
        }
    }
}
