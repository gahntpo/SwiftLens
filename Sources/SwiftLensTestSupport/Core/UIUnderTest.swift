//
//  UIUnderTest.swift
//  UserInteractionSimulationProject
//
//  Created by Karin Prater on 28/04/2025.
//
import SwiftUI
import ViewInspector
import SwiftLens

struct UIUnderTest {
    
    let simulator: UIEventSimulator
    let observer: UIObservationLens

    init<Content: View>(
        @ViewBuilder content: (_ sut: UIUnderTest) -> Content
    ) {
        let expectations = UIObservationLens()
        let notificationCenter = NotificationCenter()

        self.simulator = UIEventSimulator(notificationCenter: notificationCenter)
        self.observer = expectations

        let rootView = content(self)
            .environment(\.notificationCenter, notificationCenter)
            .onPreferenceChange(ViewMetadataKey.self) { metas in
                expectations.values = metas
            }

        ViewHosting.host(view: rootView)

        // Link simulator verification to expectations
       // self.when.expectations = expectations
    }
}
