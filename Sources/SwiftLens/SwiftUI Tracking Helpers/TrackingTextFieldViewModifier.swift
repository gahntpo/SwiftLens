//
//  TrackingTextFieldViewModifier.swift
//  SwiftLens
//
//  Created by Karin Prater on 28/04/2025.
//

import SwiftUI

extension TextField {
    public  func trackTextField(accessibilityIdentifier: String,
                        text: Binding<String>) -> some View {
        self.modifier(TrackingTextFieldViewModifier(accessibilityIdentifier: accessibilityIdentifier,
                                                    text: text))
    }
}

extension TextEditor {
   public func trackTextEditor(accessibilityIdentifier: String,
                        text: Binding<String>) -> some View {
        self.modifier(TrackingTextFieldViewModifier(accessibilityIdentifier: accessibilityIdentifier,
                                                    text: text))
    }
}

//TODO: SecureField

public struct TrackingTextFieldViewModifier: ViewModifier {
    
    let accessibilityIdentifier: String
    @Binding var text: String
    @Environment(\.notificationCenter) var notificationCenter
    @Environment(\.isEnabled) var isEnabled
    
    @FocusState var isFocused: Bool
    
    public init(accessibilityIdentifier: String,
                text: Binding<String>) {
        self.accessibilityIdentifier = accessibilityIdentifier
        self._text = text
    }
    
    public func body(content: Content) -> some View {
        content
            .preferenceTracking(
                identifier: accessibilityIdentifier,
                viewName: String(describing: Self.self),
                info: ["value": text,
                       "focused": isFocused,
                       "isEnabled" : isEnabled]
            )
            .onChange(of: text) { newValue in
           // .onChange(of: text) { _, newValue in
                sendTextFieldChange(value: newValue)
            }
            .onChange(of: isFocused) { newValue in
            // .onChange(of: isFocused, { oldValue, newValue in
                sendTextFieldFocusChange(value: newValue)
            }
            .onReceive(notificationCenter.publisher(for: .simulateTextFieldChange)) { notif in
                receivedTextFieldChange(notif)
            }
            .onReceive(notificationCenter.publisher(for: .simulateTextFieldFocusChange)) { notif in
                receivedTextFieldCommit(notif)
            }
            .accessibilityIdentifier(accessibilityIdentifier)
            
            .onSubmit {
                sendTextFieldCommitChange(value: false)
             }
            
            .focused($isFocused, equals: true)
    }

    private func sendTextFieldChange(value: String) {
        notificationCenter.post(name: .textFieldWasChanged,
                                 object: nil,
                                 userInfo: [
                                    "id": accessibilityIdentifier,
                                    "value": value
                                 ])
    }
    
    private func sendTextFieldFocusChange(value: Bool) {
        notificationCenter.post(name: .textFieldFocusChanged,
                                 object: nil,
                                 userInfo: [
                                    "id": accessibilityIdentifier,
                                    "value": self.text,
                                    "focus": value
                                 ])
    }
    
    private func sendTextFieldCommitChange(value: Bool) {
        notificationCenter.post(name: .textFieldCommitChanged,
                                 object: nil,
                                 userInfo: [
                                    "id": accessibilityIdentifier,
                                    "value": self.text
                                 ])
    }

    private func receivedTextFieldChange(_ notif: NotificationCenter.Publisher.Output) {
        guard notif.name == .simulateTextFieldChange,
              let notifId = notif.userInfo?["id"] as? String,
              let newVal = notif.userInfo?["value"] as? String,
              notifId == accessibilityIdentifier else {
            return
        }
        text = newVal
    }

    private func receivedTextFieldCommit(_ notif: NotificationCenter.Publisher.Output) {
        guard notif.name == .simulateTextFieldFocusChange,
              let notifId = notif.userInfo?["id"] as? String,
              notifId == accessibilityIdentifier,
        let focused = notif.userInfo?["focused"] as? Bool else {
            print("receivedTextFieldCommit - failure - \(notif)")
            return
        }
        print("receivedTextFieldCommit - go")
        self.isFocused = focused
        // You can trigger any special onCommit logic here if needed
        // (might need custom behavior depending on your view)
    }
}
