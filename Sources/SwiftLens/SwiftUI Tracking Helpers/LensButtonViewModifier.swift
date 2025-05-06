//
//  TrackingButtonStyle.swift
//  SwiftLens
//
//  Created by Karin Prater on 28/04/2025.
//
import SwiftUI

extension Button {
    public func lensButton(id: String) -> some View {
        self.buttonStyle(LensButtonStyle(accessibilityIdentifier: id))
    }
}

extension NavigationLink {
    public func lensButton(id: String) -> some View {
        self
             .buttonStyle(LensButtonStyle(accessibilityIdentifier: id))
            // buttonstyle not working inside list, form
            // need to apply preferences outside button style because navigationlink does not pass them
            .lensTracked(id: id)
            .accessibilityIdentifier(id)
            // cannot trigger link if inside list/navigationstack
    }
}

//TODO: EditButton, Link, Menu, MenuButton, PasteButton, RenameButton, ShareLink, SignInWithAppleButton

// Compatible with custom button styling

public struct LensButtonStyle: PrimitiveButtonStyle {

    public let accessibilityIdentifier: String
    @Environment(\.notificationCenter) var notificationCenter
    @Environment(\.isEnabled) var isEnabled
    
    public init(accessibilityIdentifier: String) {
        self.accessibilityIdentifier = accessibilityIdentifier
    }
    
    public func makeBody(configuration: Configuration) -> some View {
      Button(configuration)
            .lensTracked(
                id: accessibilityIdentifier,
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
                  configuration.trigger()
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
