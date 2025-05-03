//
//  SwiftUIView.swift
//  SwiftLens
//
//  Created by Karin Prater on 29/04/2025.
//

import SwiftUI
import SwiftLens

struct DemoSliderView: View {
    
    @State private var value: Double = 1
    
    var body: some View {
        VStack {
            Text("Slider \(value.formatted())")
         
            TrackingSlider(value: $value,
                        accessibilityIdentifier: "demo-slider")
        }
    }
}

