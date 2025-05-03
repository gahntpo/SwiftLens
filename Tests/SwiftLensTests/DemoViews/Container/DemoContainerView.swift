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
                .preferenceTracking(
                    identifier: "First",
                    viewName: "DemoContainerView"
                )
            
            VStack {
                Text("Second")
                    .preferenceTracking(
                        identifier: "Second",
                        viewName: "DemoContainerView"
                    )
                Text("Third")
                    .preferenceTracking(
                        identifier: "Third",
                        viewName: "DemoContainerView"
                    )
            }
        }
    }
}

struct DemoContainerNestedView: View {
    var body: some View {
        VStack {
            Text("First")
                .preferenceTracking(
                    identifier: "First",
                    viewName: "DemoContainerView"
                )
            
            VStack {
                Text("Second")
                    .preferenceTracking(
                        identifier: "Second",
                        viewName: "DemoContainerView"
                    )
                Text("Third")
                    .preferenceTracking(
                        identifier: "Third",
                        viewName: "DemoContainerView"
                    )
            }
            .transformPreferenceTracking(identifier: "container", viewName: "DemoContainerView")
        }
    }
}

struct DemoContainerBackgroundView: View {
    var body: some View {
        VStack {
            Text("First")
                .preferenceTracking(
                    identifier: "First",
                    viewName: "DemoContainerView"
                )
            
            VStack {
                Text("Second")
                    .preferenceTracking(
                        identifier: "Second",
                        viewName: "DemoContainerView"
                    )
                Text("Third")
                    .preferenceTracking(
                        identifier: "Third",
                        viewName: "DemoContainerView"
                    )
            }
            .transformPreferenceTracking(identifier: "container", viewName: "DemoContainerView")
            .background {
                Color.yellow
                    .preferenceTracking(
                        identifier: "Backround.id",
                        viewName: "DemoContainerView"
                    )
            }
        }
    }
}

struct DemoContainerZStackView: View {
    var body: some View {
        VStack {
            Text("First")
                .preferenceTracking(
                    identifier: "First",
                    viewName: "DemoContainerView"
                )
            
            ZStack {
                Color.yellow
                    .preferenceTracking(
                        identifier: "Yellow",
                        viewName: "DemoContainerView"
                    )
                
                VStack {
                    Text("Second")
                        .preferenceTracking(
                            identifier: "Second",
                            viewName: "DemoContainerView"
                        )
                    Text("Third")
                        .preferenceTracking(
                            identifier: "Third",
                            viewName: "DemoContainerView"
                        )
                }
            }
            .transformPreferenceTracking(identifier: "ZStack.container", viewName: "DemoContainerView")
            
        }
    }
}
