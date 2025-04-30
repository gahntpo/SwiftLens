//
//  SwiftUIView.swift
//  SwiftLens
//
//  Created by Karin Prater on 30/04/2025.
//

import SwiftUI


/// A flexible list container that behaves differently in test vs production environments
public struct LensList<Content: View>: View {
    
    // Direct content reference for content-initialized version
    private let content: Content?
    
    // Environment check for tests
    var isRunningTests: Bool {
        return ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
    }
    
    @Environment(\.defaultMinListRowHeight) var height
    
    /// Initialize with a @ViewBuilder direct content closure
    /// - Parameter content: The view content to display inside the container
    public init(content: Content) {
           self.content = content
       }
    
    public var body: some View {
        if isRunningTests {
            ScrollView {
                //cannot use LazyVStack same problme with prefences
                VStack(alignment: .leading, spacing: 0) {
                    if let content = content {
                        content
                            .frame(minWidth: height)
                            .padding()
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.yellow)
                .padding(.horizontal)
            }
        } else {
            List {
                if let content = content {
                    content
                }
            }
            
        }
    }
}

extension LensList {
    /// Initialize with a @ViewBuilder content closure
    /// - Parameter content: The view content to display inside the container
    public init(@ViewBuilder content: () -> Content) {
        self.init(content: content())
    }
}


extension LensList {
    /// Creates a list that computes its rows on demand from an underlying collection of identifiable data.
    public init<Data, RowContent>(_ data: Data, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent)
        where Content == ForEach<Data, Data.Element.ID, RowContent>,
              Data: RandomAccessCollection,
              Data.Element: Identifiable,
              RowContent: View
    {
        self.init(content: ForEach(data, id: \.id, content: rowContent))
    }

    /// Creates a list that identifies its rows based on a key path to the identifier.
    public init<Data, ID, RowContent>(_ data: Data, id: KeyPath<Data.Element, ID>, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent)
        where Content == ForEach<Data, ID, RowContent>,
              Data: RandomAccessCollection,
              ID: Hashable,
              RowContent: View
    {
        self.init(content: ForEach(data, id: id, content: rowContent))
    }
    
    /// Creates a list that computes its rows on demand from an underlying
    /// collection of identifiable data, allowing users to select multiple rows.
    public init<Data, SelectionValue, RowContent>(_ data: Data, selection: Binding<Set<SelectionValue>>?, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent)
        where Content == ForEach<Data, Data.Element.ID, RowContent>,
              Data: RandomAccessCollection,
              Data.Element: Identifiable,
              Data.Element.ID == SelectionValue,
              RowContent: View
    {
        // Note: In a real implementation, would handle selection properly
        self.init(content: ForEach(data, id: \.id, content: rowContent))
    }
}

// Example usage:

// Using direct content:
struct DirectContentExample: View {
    var body: some View {
        LensList {
            Text("Item 1")
            Text("Item 2")
            Text("Item 3")
        }
    }
}

// Using data with ForEach:
struct DataExample: View {
    struct Item: Identifiable {
        let id = UUID()
        let title: String
    }
    
    let items = [
        Item(title: "First item"),
        Item(title: "Second item"),
        Item(title: "Third item")
    ]
    
    var body: some View {
        LensList(items) { item in
            Text(item.title)
        }
    }
}
