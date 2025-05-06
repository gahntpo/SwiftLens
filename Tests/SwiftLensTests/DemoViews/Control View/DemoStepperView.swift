//
//  SwiftUIView.swift
//  SwiftLens
//
//  Created by Karin Prater on 29/04/2025.
//

import SwiftUI
import SwiftLens

struct DemoStepperView: View {
    
    @State private var quantity: CGFloat = 1
    
    var body: some View {
        VStack(spacing: 10) {
            Stepper(value: $quantity, in: 1...10) {
                Text("\(quantity)")
            }
            .lensStepper(id: "demo_stepper",
                          value: $quantity)
       
      }
    }
}
