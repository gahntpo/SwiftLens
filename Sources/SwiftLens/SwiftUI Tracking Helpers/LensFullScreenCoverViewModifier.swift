//
//  LensFullScreenCoverIsPresentedModifier.swift
//  SwiftLens
//
//  Created by Karin Prater on 04/05/2025.
//

import SwiftUI

extension View {
    public func lensFullScreenCover<Content: View>(
        id: String,
        isPresented: Binding<Bool>,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        modifier(LensFullScreenCoverIsPresentedModifier(accessibilityIdentifier: id,
                                                        isPresented: isPresented,
                                                        onDismiss: onDismiss,
                                                        fullScreenCoverContent: content))
    }
    
    public func lensFullScreenCover<Item: Identifiable & Equatable, Content: View>(
        id: String,
        item: Binding<Item?>,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping (Item) -> Content
    ) -> some View {
        modifier(
            LensFullScreenCoverItemModifier(accessibilityIdentifier: id,
                                            item: item,
                                            onDismiss: onDismiss,
                                            fullScreenCoverContent: content)
        )
    }
}

/// A view modifier that presents a fullScreenCover but also captures any
/// LensCapture emitted by the sheet’s content and re‑publishes it
/// on the parent view’s LensCaptureKey.
///
struct LensFullScreenCoverIsPresentedModifier<FullScreenCoverContent: View>: ViewModifier {
    
    public let accessibilityIdentifier: String
    @Binding var isPresented: Bool
    let onDismiss: (() -> Void)?
    let fullScreenCoverContent: () -> FullScreenCoverContent

    // Holds the latest preferences coming out of the sheet
    @State private var liftedPreferences: [LensCapture] = []
    
    var passedPreferences: [LensCapture] {
        guard isPresented else { return [] }
        guard !liftedPreferences.isEmpty else { return [] }
        
        return [LensCapture(viewType: String(describing: Self.self),
                            identifier: accessibilityIdentifier,
                            children: liftedPreferences)]
    }
    
    func body(content: Content) -> some View {
        content
           .background {
                Color.clear
                   .preference(key: LensCaptureKey.self,
                               value: passedPreferences)
            }
            .fullScreenCover(isPresented: $isPresented,
                             onDismiss: onDismiss,
                             content: {
                fullScreenCoverContent()
                    .onPreferenceChange(LensCaptureKey.self) { liftedPreferences = $0 }
            })
    }
}

private struct LensFullScreenCoverItemModifier<Item: Identifiable & Equatable, FullScreenCoverContent: View>: ViewModifier {
    
    public let accessibilityIdentifier: String
    @Binding var item: Item?
    let onDismiss: (() -> Void)?
    let fullScreenCoverContent: (Item) -> FullScreenCoverContent

    @State private var liftedPreferences: [LensCapture] = []

    var passedPreferences: [LensCapture] {
        guard item != nil else { return [] }
        guard !liftedPreferences.isEmpty else { return [] }
        
        return [LensCapture(viewType: String(describing: Self.self),
                            identifier: accessibilityIdentifier,
                            children: liftedPreferences)]
    }
    
    @ViewBuilder
    func body(content: Content) -> some View {
        content
           // Re‑emit the sheet’s prefs onto the parent’s preference tree
            .background {
                Color.clear
                    .preference(key: LensCaptureKey.self,
                                value: passedPreferences)
            }
            .fullScreenCover(item: $item,
                             onDismiss: onDismiss,
                             content: { item in
                fullScreenCoverContent(item)
                    .onPreferenceChange(LensCaptureKey.self) { liftedPreferences = $0 }
            })
    }
}
