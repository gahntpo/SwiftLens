//
//  SwiftUIView.swift
//  SwiftLens
//
//  Created by Karin Prater on 28/04/2025.
//

import SwiftUI
import SwiftLens

struct Item: Identifiable {
    var name: String
    let id: UUID
    init(name: String, id: UUID = UUID()) {
        self.name = name
        self.id = id
    }
    
    static var examples: [Item] {
        [Item(name: "first"), Item(name: "second"), Item(name: "third")]
    }
}

protocol TestableViewModelProtocol: ObservableObject {
    var items: [Item] { get set }
    func removeLast()
}

final class MockViewModel: TestableViewModelProtocol {
    
    @Published var didCallAction = false
    @Published var items: [Item] = Item.examples
    
    func removeLast() {
        didCallAction = true
        
        guard items.isEmpty == false else { return }
        items.removeLast()
    }
}

final class DefaultViewModel: TestableViewModelProtocol {

    @Published var items: [Item] = Item.examples
    
    func removeLast() {
        guard items.isEmpty == false else { return }
        items.removeLast()
    }
}


struct DemoButtonView<VM: TestableViewModelProtocol>: View  {
    
    @ObservedObject var viewModel: VM

     var body: some View {
         VStack {
             // not working with list
             LensList {
                 if viewModel.items.isEmpty {
                     EmptyItemView()
                         .lensTracked(id: "demo_items_empty_placeholder")
                 } else {
                     ForEach(viewModel.items) { item in
                         Text(item.name)
                             .padding()
                             .background(Capsule().fill(Color.yellow))
                             .lensTracked(id: "item.\(item.id)")
                     }
                 }
             }
             
             Divider()
             
             Button("Remove Last") {
                 viewModel.removeLast()
             }
             .lensButton(id: "RemoveLastButton")
             .buttonStyle(.borderedProminent)
             .disabled(viewModel.items.isEmpty)
             
         }
         .lensGroup(id: "demo.list")
         
         // This will overwrite the child preference keys:
         //.lensTracked(id: "demo_listr")
     }
}

struct EmptyItemView: View {
    var body: some View {
        if #available(iOS 17.0, *) {
            ContentUnavailableView("No Items Found", systemImage: "book.pages")
        } else {
            Label("No Items Found", systemImage:  "book.pages")
        }
    }
}

/*
#Preview {
    var vm = DefaultViewModel()
    DemoButtonView(viewModel: vm)
}
*/


