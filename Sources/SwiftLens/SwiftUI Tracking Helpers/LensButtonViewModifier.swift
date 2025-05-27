//
//  TrackingButtonStyle.swift
//  SwiftLens
//
//  Created by Karin Prater on 28/04/2025.
//
import SwiftUI

extension Button {
    public func lensButton(id: String,
                           info: [String : AnyHashable] = [:]) -> some View {
        self.buttonStyle(LensButtonStyle(accessibilityIdentifier: id,
                                         info: info))
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
    let info: [String : AnyHashable]
    
    @Environment(\.notificationCenter) var notificationCenter
    @Environment(\.isEnabled) var isEnabled
    
    public init(accessibilityIdentifier: String,
                info: [String : AnyHashable] = [:]) {
        self.accessibilityIdentifier = accessibilityIdentifier
        self.info = info
    }
    
    public func makeBody(configuration: Configuration) -> some View {
      Button(configuration)
            .lensTracked(
                id: accessibilityIdentifier,
                info: info(for: configuration)
            )
      //TODO: only add notification if custom flag is set
     // #if DEBUG
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
    
    func info(for configuration: PrimitiveButtonStyleConfiguration) -> [String: AnyHashable] {
        var info = self.info
        info["isEnabled"] = isEnabled
        
        if let role = configuration.role {
            switch role {
                case .cancel: info["role"] = 4
                case .destructive: info["role"] = 1
                default:
                    info["role"] = 0
            }
        } else {
            info["role"] = 0
        }
        return info
    }
}

