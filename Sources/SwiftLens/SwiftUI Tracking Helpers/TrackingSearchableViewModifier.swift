//
//  SwiftUIView.swift
//  SwiftLens
//
//  Created by Karin Prater on 05/05/2025.
//

import SwiftUI

extension View {
    public func trackSearchable(text: Binding<String>,
                               accessibilityIdentifier: String,
                               placement: SearchFieldPlacement = .automatic,
                               prompt: Text? = nil) -> some View {
        self.searchable(text: text,
                        placement: placement,
                        prompt: prompt)
        .modifier(TrackingSearchableModifier(text: text,
                                             accessibilityIdentifier: accessibilityIdentifier))
    }
}

struct TrackingSearchableModifier: ViewModifier {
    
    @Binding var text: String
    let accessibilityIdentifier: String
    
    @Environment(\.notificationCenter) private var notificationCenter

    func body(content: Content) -> some View {
        content
            .background(
                Color.clear
                    .preferenceTracking(identifier: accessibilityIdentifier,
                                        viewName: "lensSearchable",
                                        info: ["value" : text])
            )
            .onReceive(notificationCenter.publisher(for: .simulateTextFieldChange)) { notif in
                receivedTextFieldChange(notif)
            }
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
}
