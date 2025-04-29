//
//  UIUnderTest.swift
//  UserInteractionSimulationProject
//
//  Created by Karin Prater on 28/04/2025.
//
import SwiftUI
import SwiftLens

@MainActor
struct UIUnderTest {
    
    let simulator: UIEventSimulator
    let observer: UIObservationLens
    private let functionName: String
    
    init<Content: View>(
        @ViewBuilder content: (_ sut: UIUnderTest) -> Content,
        function: String = #function
    ) {
        let expectations = UIObservationLens()
        let notificationCenter = NotificationCenter()
        self.functionName = function
        
        self.simulator = UIEventSimulator(notificationCenter: notificationCenter)
        self.observer = expectations
        
        let rootView = content(self)
            .environment(\.notificationCenter, notificationCenter)
            .onPreferenceChange(ViewMetadataKey.self) { metas in
                expectations.values = metas
            }
        
        // Use Task to call the @MainActor host method
        ViewHosting.host(view: rootView, function: function)
    }
}
