//
//  TrackingButtonStyle.swift
//  SwiftLens
//
//  Created by Karin Prater on 28/04/2025.
//
import SwiftUI

extension Button {
    public func trackButton(accessibilityIdentifier: String) -> some View {
        self.buttonStyle(TrackingButtonStyle(accessibilityIdentifier: accessibilityIdentifier))
    }
}

extension NavigationLink {
    public func trackButton(accessibilityIdentifier: String) -> some View {
        self
             .buttonStyle(TrackingButtonStyle(accessibilityIdentifier: accessibilityIdentifier))
            // buttonstyle not working inside list, form
            // need to apply preferences outside button style because navigationlink does not pass them
            .preferenceTracking(
                identifier: accessibilityIdentifier,
                viewName: String(describing: Self.self)
            )
    }
}

//TODO: EditButton, Link, Menu, MenuButton, PasteButton, RenameButton, ShareLink, SignInWithAppleButton

// Compatible with custom button styling

public struct TrackingButtonStyle: PrimitiveButtonStyle {

    public let accessibilityIdentifier: String
    @Environment(\.notificationCenter) var notificationCenter
    @Environment(\.isEnabled) var isEnabled
    
    public init(accessibilityIdentifier: String) {
        self.accessibilityIdentifier = accessibilityIdentifier
    }
    
    public func makeBody(configuration: Configuration) -> some View {
      Button(configuration)
            .preferenceTracking(
                identifier: accessibilityIdentifier,
                viewName: String(describing: Self.self),
                info: ["isEnabled" : isEnabled]
            )
      //TODO: only add notification if custom flag is set
     // #if DEBUG
          .simultaneousGesture(TapGesture().onEnded({ _ in
              sendButtonNotification()
          }))
      // #endif
          .onReceive(notificationCenter.publisher(for: .simulateButtonTap)) { notification in
              if let id = notification.userInfo?["id"] as? String,
                 self.accessibilityIdentifier == id {
                  print("notification received -> simulate button press")
                  configuration.trigger()
                  //TODO: add visual indicator to show what button was triggered (only if custom flag)
              }
          }
          .accessibilityIdentifier(accessibilityIdentifier)
   }
    
    func sendButtonNotification() {
        notificationCenter.post(name: .buttonWasTapped,
                                object: nil,
                                userInfo: ["id": accessibilityIdentifier])
    }
}
