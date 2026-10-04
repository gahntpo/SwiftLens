//
//  LensWorkBench.swift
//
//  Created by Karin Prater on 28/04/2025.
//
import SwiftUI
import SwiftLens

#if os(iOS) || os(visionOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

@MainActor
public struct LensWorkBench {
    
    public let interactor: LensInteractor
    public let observer: LensObserver
    
    #if os(iOS) || os(visionOS)
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
        
        let rootVC = window.rootViewController!
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        hostingController.willMove(toParent: rootVC)
        rootVC.addChild(hostingController)
        rootVC.view.addSubview(hostingController.view)
        
        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: rootVC.view.leadingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: rootVC.view.topAnchor),
            hostingController.view.widthAnchor.constraint(equalTo: rootVC.view.widthAnchor),
            hostingController.view.heightAnchor.constraint(equalTo: rootVC.view.heightAnchor)
        ])
        
        hostingController.didMove(toParent: rootVC)
        window.layoutIfNeeded()
        
        expectations.setFailureHandler { [self] message in
            self.attachSnapshotToXCTest(name: message)
        }
    }
    #elseif os(macOS)
    public var window: NSWindow!
    public var hostingView: NSHostingView<AnyView>?
    
    public init<Content: View>(
        @ViewBuilder content: (_ sut: LensWorkBench) -> Content
    ) {
        let expectations = LensObserver()
        let notificationCenter = NotificationCenter()
        
        self.interactor = LensInteractor(notificationCenter: notificationCenter)
        self.observer = expectations
        self.window = nil
        self.hostingView = nil
        
        let rootView = content(self)
            .environment(\.notificationCenter, notificationCenter)
            .onPreferenceChange(LensCaptureKey.self) { metas in
                expectations.values = metas
            }
        
        let hostingView = NSHostingView(rootView: AnyView(rootView))
        self.hostingView = hostingView
        
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 800, height: 600),
            styleMask: [.titled, .closable, .resizable],
            backing: .buffered,
            defer: false
        )
        window.contentView = hostingView
        window.makeKeyAndOrderFront(nil)
        self.window = window
        
        hostingView.layoutSubtreeIfNeeded()
        window.layoutIfNeeded()
        // Allow SwiftUI rendering to propagate preferences
        CFRunLoopRunInMode(CFRunLoopMode.defaultMode, 0.01, false)
        
        expectations.setFailureHandler { [self] message in
            self.attachSnapshotToXCTest(name: message)
        }
    }
    #endif
    
    func waitForAndTapButton(_ id: String) async throws {
        try await self.observer.waitForViewVisible(withID: id)
        self.interactor.tapButton(withID: id)
    }
}
