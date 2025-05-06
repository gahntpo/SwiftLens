//
//  SwiftUIView.swift
//  SwiftLens
//
//  Created by Karin Prater on 29/04/2025.
//

import SwiftUI

class ToggleViewModel: ObservableObject {
    @Published var isTrue = false
}

struct DemoToggleView: View {
    
    @ObservedObject var vm: ToggleViewModel
    
    var body: some View {
        VStack {
            
            Toggle("Toogle", isOn: $vm.isTrue)
                .trackToggle(accessibilityIdentifier: "CheckList_toggle",
                             value: $vm.isTrue)
                .toggleStyle(.button)
            
            
            if vm.isTrue {
                Text("You can toggle this on and off")
                    .lensTracked(id: "text.toggled.visible")
            }
            
        }
    }
}

