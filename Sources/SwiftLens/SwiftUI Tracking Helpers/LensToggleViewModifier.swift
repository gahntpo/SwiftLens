//
//  TrackingToggleViewModifier.swift
//  SwiftLens
//
//  Created by Karin Prater on 28/04/2025.
//
import SwiftUI

extension Toggle {
    public func lensToggle(id: String,
                           value: Binding<Bool>) -> some View {
        self.modifier(LensToggleViewModifier(accessibilityIdentifier: id,
                                                 value: value))
    }
}

public struct LensToggleViewModifier: ViewModifier {
    
    let accessibilityIdentifier: String
    @Binding var value: Bool
    
    @Environment(\.notificationCenter) var notificationCenter
    @Environment(\.isEnabled) var isEnabled
    
   public init(accessibilityIdentifier: String,
         value: Binding<Bool>) {
        self.accessibilityIdentifier = accessibilityIdentifier
        self._value = value
    }
    
    public func body(content: Content) -> some View {
        content
            .lensTracked(id: accessibilityIdentifier,
                         info: ["value" : value,
                                "isEnabled" : isEnabled])
            .onChange(of: value) {newValue in
                sendToggleNotification(value: newValue)
            }
            .onReceive(notificationCenter.publisher(for: .simulateToggleChange)) { notif in
                receivedToggleNotification(notif: notif)
            }
            .accessibilityIdentifier(accessibilityIdentifier)
    }
    
    func sendToggleNotification(value: Bool) {
        notificationCenter.post(name: .toggleWasChanged,
                                object: nil,
                                userInfo: ["id": accessibilityIdentifier,
                                           "value": value])
    }
    
    func receivedToggleNotification(notif: NotificationCenter.Publisher.Output) {
        guard let notifId = notif.userInfo?["id"] as? String,
              notifId == accessibilityIdentifier else { return }
            
        if let newVal = notif.userInfo?["value"] as? Bool {
            value = newVal
        } else {
            value.toggle()
        }
    }
}
