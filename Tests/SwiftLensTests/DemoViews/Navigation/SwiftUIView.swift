//
//  SwiftUIView.swift
//  SwiftLens
//
//  Created by Karin Prater on 06/05/2025.
//

import SwiftUI
import SwiftLens

@available(iOS 16.0, *)
struct DemoListItemView: View {

    @ObservedObject var fetcher: CategoryFetcher
    
    var body: some View {
        NavigationStack {
            CategoryListView(fetcher: fetcher)
                .navigationDestination(for: Category.self) { category in
                    CategoryDetailView(category: category)
                }
        }
    }
}

@available(iOS 16.0, *)
fileprivate struct CategoryListView: View {
    
    @ObservedObject var fetcher: CategoryFetcher
    @State private var selection: Category?
    
    var body: some View {
        LensList(fetcher.categories, id: \.self) { category in
            NavigationLink(value: category) {
                Label(category.title, systemImage: category.icon)
            }
            .lensButton(id: "link.category.\(category.id)")
        }
        .task {
            await fetcher.loadCategories()
        }
        .lensGroup(id: "category.list.view.\(fetcher.state.description)")
    }
}
