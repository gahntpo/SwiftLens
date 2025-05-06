//
//  SwiftUIView.swift
//  SwiftLens
//
//  Created by Karin Prater on 05/05/2025.
//

import SwiftUI

final class SearchViewModel: ObservableObject {

    @Published var items: [Item] = Item.examples
    
    @Published var searchText = ""
    
    var result: [Item] {
        guard searchText.isEmpty == false else {
            return items
        }
        
        return items.filter({ $0.name.localizedCaseInsensitiveContains(searchText) })
    }
}


@available(iOS 16.0, *)
struct DemoSearchableView: View {
    
    @StateObject var viewModel = SearchViewModel()
    @Environment(\.notificationCenter) private var notificationCenter
    
    var body: some View {
        NavigationStack {
            List(viewModel.result) { item in
                Text(item.name)
                    .lensTracked(id: "item.\(item.id)")
            }
            .trackSearchable(text: $viewModel.searchText,
                            accessibilityIdentifier: "searchtext")
        }
    }
}


