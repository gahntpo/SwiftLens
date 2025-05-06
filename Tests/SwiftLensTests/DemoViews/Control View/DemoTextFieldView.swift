//
//  SwiftUIView.swift
//  SwiftLens
//
//  Created by Karin Prater on 29/04/2025.
//

import SwiftUI

protocol TestableTextViewModelProtocol: ObservableObject {
    var text: String { get set }
    func submit()
}

final class MockTextViewModel: TestableTextViewModelProtocol {
    
    @Published var didCallAction = false
    @Published var text = ""
    
    func submit() {
        didCallAction = true
    }
}

final class DefaultTextViewModel: TestableTextViewModelProtocol {

    @Published var text = ""
    
    func submit()  {
       print("do somthing after submit")
    }
}

struct DemoTextFieldView<VM: TestableTextViewModelProtocol>: View  {
    
    @ObservedObject var viewModel: VM
    
    var body: some View {
        VStack {
            TextField("Enter text", text: $viewModel.text)
                .lensTextField(id: "demo_textfield",
                                text: $viewModel.text)
                .textFieldStyle(.roundedBorder)
              //  .onSubmit {
              //      print("submit outside still works")
              //  }
            
            
        }
    }
}


