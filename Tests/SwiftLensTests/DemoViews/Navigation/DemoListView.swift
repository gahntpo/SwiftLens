//
//  TestListView.swift
//  UserInteractionSimulationProject
//
//  Created by Karin Prater on 03/05/2025.
//

import SwiftUI
import SwiftLens

@available(iOS 16.0, *)
struct DemoListView: View {
    
    enum ContainerStyle {
        case list
        case scrollview
        case vstack
        case lazyvstack
        case form
        case lensList
    }
    
    
    @ObservedObject var fetcher: CategoryFetcher
    let containerStyle: ContainerStyle
    let rowContentStyle: CategoryRow.ContentStyle
    
    var body: some View {
        VStack {
            switch fetcher.state {
                case .idle:
                    container
                case .loading:
                    ProgressView()
                case .error(let string):
                    Text(string)
                        .foregroundStyle(.pink)
            }
        }
   
        .navigationTitle("Shop by Category")
        .toolbar(content: {
            Button {
                
            } label: {
                Label("settings", systemImage: "gear")
            }
            
        })
        .task {
            await fetcher.loadCategories()
        }
        .lensGroup(id: "category.list.view.\(fetcher.state.description)")
    }
    
    @ViewBuilder
    var container: some View {
        switch containerStyle {
            case .list:
                List {
                    ForEach(fetcher.categories) { category in
                        CategoryRow(category: category,
                                    contentStyle: rowContentStyle)
                    }
                }
            case .scrollview:
                ScrollView {
                    ForEach(fetcher.categories) { category in
                        CategoryRow(category: category,
                                    contentStyle: rowContentStyle)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.yellow)
                    }
                    
                    .padding()
                }
                .background(Color(white: 0.9))
            case .vstack:
                VStack {
                    ForEach(fetcher.categories) { category in
                        CategoryRow(category: category,
                                    contentStyle: rowContentStyle)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.yellow)
                    }
                }
                .padding()
                .background(Color(white: 0.9))
            case .lazyvstack:
                ScrollView {
                    LazyVStack {
                        ForEach(fetcher.categories) { category in
                            CategoryRow(category: category,
                                        contentStyle: rowContentStyle)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.yellow)
                        }
                    }
                    .padding()
                }
                .background(Color(white: 0.9))
            case .form:
                Form {
                    ForEach(fetcher.categories) { category in
                        CategoryRow(category: category,
                                    contentStyle: rowContentStyle)
                    }
                }
            case .lensList:
                LensList {
                    ForEach(fetcher.categories) { category in
                        CategoryRow(category: category,
                                    contentStyle: rowContentStyle)
                    }
                }
        }
    }
}

@available(iOS 16.0, *)
struct CategoryRow: View {
    
    let category: Category
    let contentStyle: ContentStyle
    
    enum ContentStyle {
        case navigationlink
        case button
        case lable
    }
    
    
    var body: some View {
        switch contentStyle {
            case .navigationlink:
                NavigationLink(value: category) {
                    Label(category.title, systemImage: category.icon)
                }
                
                .lensButton(id: "link.category.\(category.id)")
               
            case .button:
                Button {
                    
                } label: {
                    Label(category.title, systemImage: category.icon)
                }
                .lensButton(id: "link.category.\(category.id)")
            case .lable:
                Label(category.title, systemImage: category.icon)
                    .lensTracked(id: "link.category.\(category.id)")
        }

        
    }
}

@available(iOS 16.0, *)
#Preview {
    DemoListView(fetcher: CategoryFetcher(),
                 containerStyle: .list,
                 rowContentStyle: .lable)
}
