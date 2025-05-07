//
//  SwiftUIView.swift
//  SwiftLens
//
//  Created by Karin Prater on 29/04/2025.
//


import SwiftUI
import SwiftLens

struct DemoTextEditorView: View {
    
    @State private var text = ""
    @State private var othertext = ""
    
    var body: some View {
        VStack {
            Text("other text")
            
            TextEditor(text: $text)
                .lensTextEditor(id: "demo_texteditor",
                                text: $text)
            
            TextEditor(text: $othertext)
                .lensTextEditor(id: "other_texteditor",
                                text: $othertext)
        }
    }
}


