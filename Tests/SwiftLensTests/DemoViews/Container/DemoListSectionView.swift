//
//  SwiftUIView.swift
//  SwiftLens
//
//  Created by Karin Prater on 07/05/2025.
//

import SwiftUI
import SwiftLens

struct DemoListSectionView: View {
    var body: some View {
        List {
            Section("First Section") {
                ForEach(0..<5, id: \.self) { index in
                    Text("item \(index)")
                        .lensTracked(id: "item.\(index)")
                }
            }
            .lensGroup(id: "section.first")
            .transformPreference(LensCaptureKey.self) { capture in
                capture[0].info["section"] = "section.first"
            }
            
            Section("Next") {
                Text("Next")
            }
        }
        .onPreferenceChange(LensCaptureKey.self) { meta in
            print(meta)
        }
    }
}

