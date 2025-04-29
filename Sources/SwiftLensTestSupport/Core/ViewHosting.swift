//
//  ViewHosting.swift
//  SwiftLens
//
//  Created by Karin Prater on 29/04/2025.
//

import SwiftUI
#if canImport(UIKit)
import UIKit
#endif
#if canImport(AppKit)
import AppKit
#endif

@MainActor
public enum ViewHosting {
    private static var hostedViews = [String: Any]()
    
    #if os(iOS) || os(tvOS)
    private static var window: UIWindow = {
        let frame = UIScreen.main.bounds
        let window = UIWindow(frame: frame)
        let rootVC = UIViewController()
        window.rootViewController = rootVC
        window.makeKeyAndVisible()
        return window
    }()
    
    @MainActor
    public static func host<V>(view: V, function: String = #function) where V: View {
        let hostingController = UIHostingController(rootView: view)
        let key = function
        
        // Store reference to prevent deallocation
        hostedViews[key] = hostingController
        
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
    
    @MainActor
    public static func expel(function: String = #function) {
        let key = function
        guard let hostingController = hostedViews.removeValue(forKey: key) as? UIHostingController<AnyView> else {
            return
        }
        
        hostingController.willMove(toParent: nil)
        hostingController.view.removeFromSuperview()
        hostingController.removeFromParent()
        hostingController.didMove(toParent: nil)
    }
    #elseif os(macOS)
    private static var window: NSWindow = {
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 800, height: 600),
            styleMask: [.titled, .resizable, .miniaturizable, .closable],
            backing: .buffered,
            defer: false)
        let rootVC = NSViewController()
        rootVC.view = NSView()
        window.contentViewController = rootVC
        window.makeKeyAndOrderFront(nil)
        return window
    }()
    
    @MainActor
    public static func host<V>(view: V, function: String = #function) where V: View {
        let hostingController = NSHostingController(rootView: view)
        let key = function
        
        // Store reference to prevent deallocation
        hostedViews[key] = hostingController
        
        // Add as child of root view controller
        let rootVC = window.contentViewController!
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        
        // Add to parent
        rootVC.addChild(hostingController)
        rootVC.view.addSubview(hostingController.view)
        
        // Setup constraints
        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: rootVC.view.leadingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: rootVC.view.topAnchor),
            hostingController.view.widthAnchor.constraint(equalTo: rootVC.view.widthAnchor),
            hostingController.view.heightAnchor.constraint(equalTo: rootVC.view.heightAnchor)
        ])
        
        window.layoutIfNeeded()
    }
    
    @MainActor
    public static func expel(function: String = #function) {
        let key = function
        guard let hostingController = hostedViews.removeValue(forKey: key) as? NSHostingController<AnyView> else {
            return
        }
        
        hostingController.view.removeFromSuperview()
        hostingController.removeFromParent()
    }
    #elseif os(watchOS)
    // watchOS implementation would go here if needed
    #endif
}
