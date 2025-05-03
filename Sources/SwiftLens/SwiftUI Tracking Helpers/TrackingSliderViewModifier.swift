//
//  TrackingSlider.swift
//  SwiftLens
//
//  Created by Karin Prater on 28/04/2025.
//
import SwiftUI

public struct TrackingSlider: View {
    
    @Binding var value: Double
    @State private var internalValue: Double
    
    let accessibilityIdentifier: String
    @Environment(\.notificationCenter) var notificationCenter
    @Environment(\.isEnabled) var isEnabled
    
    public init(value: Binding<Double>,
                accessibilityIdentifier: String) {
        self._value = value
        self._internalValue = State(initialValue: value.wrappedValue)
        self.accessibilityIdentifier = accessibilityIdentifier
    }
    
    public var body: some View {
        Slider(value: $internalValue) { hasChanged in
            if !hasChanged {
                self.value = internalValue
                sendSliderNotification(value: internalValue)
            }
        }
        .onReceive(notificationCenter.publisher(for: .simulateSliderChange)) { notification in
            print("slider value changed \(notification)")
            if let id = notification.userInfo?["id"] as? String,
               self.accessibilityIdentifier == id,
               let value = notification.userInfo?["value"] as? Double {
                self.value = value
                self.internalValue = value
            }
        }
        .preferenceTracking(identifier: accessibilityIdentifier,
                            viewName: String(describing: Self.self),
                            info: ["value" : value,
                                   "isEnabled" : isEnabled])
        .accessibilityIdentifier(accessibilityIdentifier)
    }
    
    private func sendSliderNotification(value: Double) {
        notificationCenter.post(name: .sliderWasChanged,
                                object: nil,
                                userInfo: [
                                    "id": accessibilityIdentifier,
                                    "value": value
                                ])
    }
}
