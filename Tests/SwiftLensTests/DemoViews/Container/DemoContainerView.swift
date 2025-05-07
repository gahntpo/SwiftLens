//
//
//  SwiftUIView.swift
//  SwiftLens
//
//  Created by Karin Prater on 02/05/2025.
//

import SwiftUI

struct DemoContainerView: View {
    var body: some View {
        VStack {
            Text("First")
                .lensTracked(id: "First")
            VStack {
                Text("Second")
                    .lensTracked(id: "Second")
                Text("Third")
                    .lensTracked(id: "Third")
            }
        }
    }
}

struct DemoContainerNestedView: View {
    var body: some View {
        VStack {
            Text("First")
                .lensTracked(id: "First")
            
            VStack {
                Text("Second")
                    .lensTracked(id: "Second")
                Text("Third")
                    .lensTracked(id: "Third")
            }
            .lensGroup(id: "container")
        }
    }
}

struct DemoContainerPlaceholderView: View {
    var body: some View {
        VStack {
            Text("First")
                .lensTracked(id: "First")
            
            VStack {
                Text("Placeholder")
            }
            .lensGroup(id: "container")
        }
    }
}

struct DemoContainerBackgroundView: View {
    var body: some View {
        VStack {
            Text("First")
                .lensTracked(id: "First")
            
            VStack {
                Text("Second")
                    .lensTracked(id: "Second")
                Text("Third")
                    .lensTracked(id: "Third")
            }
            .lensGroup(id: "container")
            .background {
                Color.yellow
                    .lensTracked(id: "Backround.id")
            }
        }
    }
}

struct DemoContainerZStackView: View {
    var body: some View {
        VStack {
            Text("First")
                .lensTracked(id: "First")
            
            ZStack {
                Color.yellow
                    .lensTracked(id: "Yellow")
                
                VStack {
                    Text("Second")
                        .lensTracked(id: "Second")
                    Text("Third")
                        .lensTracked(id: "Third")
                }
            }
            .lensGroup(id: "ZStack.container")
        }
    }
}
