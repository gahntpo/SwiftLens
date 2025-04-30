//
//  UIUnderTest.swift
//  UserInteractionSimulationProject
//
//  Created by Karin Prater on 28/04/2025.
//
import SwiftUI
import SwiftLens

@MainActor
public struct UIUnderTest {
    
    public let simulator: UIEventSimulator
    public let observer: UIObservationLens
    
    private var window: UIWindow
    
    public init<Content: View>(
        @ViewBuilder content: (_ sut: UIUnderTest) -> Content
    ) {
        let expectations = UIObservationLens()
        let notificationCenter = NotificationCenter()
        
        self.simulator = UIEventSimulator(notificationCenter: notificationCenter)
        self.observer = expectations
        
        self.window = {
            let frame = UIScreen.main.bounds
            let window = UIWindow(frame: frame)
            let rootVC = UIViewController()
            window.rootViewController = rootVC
            window.makeKeyAndVisible()
            return window
        }()
        
        let rootView = content(self)
            .environment(\.notificationCenter, notificationCenter)
            .onPreferenceChange(ViewMetadataKey.self) { metas in
                expectations.values = metas
            }
        

        let hostingController = UIHostingController(rootView: rootView)
        
        // Add as child of root view controller
        let rootVC = window.rootViewController!
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        
        // Add to parent
        hostingController.willMove(toParent: rootVC)
        rootVC.addChild(hostingController)
        rootVC.view.addSubview(hostingController.view)
        
        // Setup constraints
        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: rootVC.view.leadingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: rootVC.view.topAnchor),
            hostingController.view.widthAnchor.constraint(equalTo: rootVC.view.widthAnchor),
            hostingController.view.heightAnchor.constraint(equalTo: rootVC.view.heightAnchor)
        ])
        
        hostingController.didMove(toParent: rootVC)
        window.layoutIfNeeded()
    }
}
