//
//  TrackingPickerViewModifier.swift
//  SwiftLens
//
//  Created by Karin Prater on 28/04/2025.
//

import SwiftUI

extension Picker {
    public func trackPicker<V: Hashable>(
        accessibilityIdentifier: String,
        selection: Binding<V>
    ) -> some View {
        self.modifier(TrackingPickerViewModifier(accessibilityIdentifier: accessibilityIdentifier, selection: selection))
    }
}

extension DatePicker {
    public func trackPicker (
        accessibilityIdentifier: String,
        selection: Binding<Date>
    ) -> some View {
        self.modifier(TrackingPickerViewModifier(accessibilityIdentifier: accessibilityIdentifier, selection: selection))
    }
}

//TODO: ColorPicker, MultiDatePicker, PhotoPicker

public struct TrackingPickerViewModifier<V>: ViewModifier where V: Hashable {
    
   let accessibilityIdentifier: String
   @Binding var selection: V
    
    @Environment(\.notificationCenter) var notificationCenter
    @Environment(\.isEnabled) var isEnabled
    
    public init(accessibilityIdentifier: String,
                selection: Binding<V>, ) {
        self.accessibilityIdentifier = accessibilityIdentifier
        self._selection = selection
    }

    public func body(content: Content) -> some View {
        content
            .lensTracked(
                id: accessibilityIdentifier,
                info: ["value": selection,
                       "isEnabled" : isEnabled]
            )
            .onChange(of: selection) { newValue in
                sendPickerNotification(value: newValue)
            }
            .onReceive(notificationCenter.publisher(for: .simulatePickerChange)) { notif in
                receivedPickerNotification(notif)
            }
            .accessibilityIdentifier(accessibilityIdentifier)
    }

    private func sendPickerNotification(value: V) {
        notificationCenter.post(name: .pickerWasChanged,
                                 object: nil,
                                 userInfo: [
                                    "id": accessibilityIdentifier,
                                    "value": value
                                 ])
    }

    private func receivedPickerNotification(_ notif: NotificationCenter.Publisher.Output) {
        guard notif.name == .simulatePickerChange,
              let notifId = notif.userInfo?["id"] as? String,
              let newVal = notif.userInfo?["value"] as? V,
              notifId == accessibilityIdentifier else {
            return
        }
        selection = newVal
    }
}
