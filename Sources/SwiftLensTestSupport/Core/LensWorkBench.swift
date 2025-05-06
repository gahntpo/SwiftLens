//
//  LensWorkBench.swift
//
//  Created by Karin Prater on 28/04/2025.
//
import SwiftUI
import SwiftLens

@MainActor
public struct LensWorkBench {
    
    public let interactor: LensInteractor
    public let observer: LensObserver
    
    public var window: UIWindow
    public var hostingController: UIViewController?
    
    public init<Content: View>(
        @ViewBuilder content: (_ sut: LensWorkBench) -> Content
    ) {
        let expectations = LensObserver()
        let notificationCenter = NotificationCenter()
        
        self.interactor = LensInteractor(notificationCenter: notificationCenter)
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
            .onPreferenceChange(LensCaptureKey.self) { metas in
                expectations.values = metas
            }
        
        
        let hostingController = UIHostingController(rootView: rootView)
        self.hostingController = hostingController
        
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
        
        /*
         
       // 0.346sec
         let hostingController = UIHostingController(rootView: rootView)
         self.hostingController = hostingController
         
         // Create a navigation controller and set it as the window's root
         let navController = UINavigationController(rootViewController: hostingController)
         window.rootViewController = navController

        // Force layout
         window.layoutIfNeeded()
         */
    }
    
    //MARK: - interactions
    func waitForAndTap(_ id: String) async throws {
        try await self.observer.waitForViewVisible(withID: id)
        self.interactor.tapButton(withID: id)
    }
}
