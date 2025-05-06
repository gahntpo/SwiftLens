//
//  TrackingStepperViewModifier.swift
//  SwiftLens
//
//  Created by Karin Prater on 28/04/2025.
//

import SwiftUI

extension Stepper {
   public func trackStepper<V: Strideable & Hashable>(
        accessibilityIdentifier: String,
        value: Binding<V>
    ) -> some View {
        self.modifier(TrackingStepperViewModifier(accessibilityIdentifier: accessibilityIdentifier, value: value))
    }
}

public struct TrackingStepperViewModifier<V>: ViewModifier where V: Strideable & Hashable {
    
    let accessibilityIdentifier: String
     @Binding var value: V
    
    @Environment(\.notificationCenter) var notificationCenter
    @Environment(\.isEnabled) var isEnabled
    
    public init(accessibilityIdentifier: String,
                value: Binding<V>) {
        self.accessibilityIdentifier = accessibilityIdentifier
        self._value = value
    }

    public func body(content: Content) -> some View {
        content
            .lensTracked(
                id: accessibilityIdentifier,
                info: ["value": value,
                       "isEnabled" : isEnabled]
            )
            .onChange(of: value) { newValue in
                sendStepperNotification(value: newValue)
            }
            .onReceive(notificationCenter.publisher(for: .simulateStepperChange)) { notif in
                receivedStepperNotification(notif)
            }
            .accessibilityIdentifier(accessibilityIdentifier)
    }

    private func sendStepperNotification(value: V) {
        notificationCenter.post(name: .stepperWasChanged,
                                 object: nil,
                                 userInfo: [
                                    "id": accessibilityIdentifier,
                                    "value": value
                                 ])
    }

    private func receivedStepperNotification(_ notif: NotificationCenter.Publisher.Output) {
        guard notif.name == .simulateStepperChange,
              let notifId = notif.userInfo?["id"] as? String,
              let newVal = notif.userInfo?["value"] as? V,
              notifId == accessibilityIdentifier else {
            return
        }
        value = newVal
    }
}
