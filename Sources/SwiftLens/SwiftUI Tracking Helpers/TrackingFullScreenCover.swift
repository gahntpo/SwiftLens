//
//  SwiftUIView.swift
//  SwiftLens
//
//  Created by Karin Prater on 04/05/2025.
//

import SwiftUI

extension View {
   public func trackingFullScreenCover<Content: View>(
        isPresented: Binding<Bool>,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        modifier(TrackingFullScreenCoverIsPresentedModifier(isPresented: isPresented,
                                                            onDismiss: onDismiss,
                                                            fullScreenCoverContent: content))
    }
    
   public func trackingFullScreenCover<Item: Identifiable & Equatable, Content: View>(
          item: Binding<Item?>,
          onDismiss: (() -> Void)? = nil,
          @ViewBuilder content: @escaping (Item) -> Content
      ) -> some View {
          modifier(
            TrackingFullScreenCoverItemModifier(item: item,
                                                onDismiss: onDismiss,
                                                fullScreenCoverContent: content)
          )
      }
}

/// A view modifier that presents a fullScreenCover but also captures any
/// ViewMetadata emitted by the sheet’s content and re‑publishes it
/// on the parent view’s ViewMetadataKey.
///
struct TrackingFullScreenCoverIsPresentedModifier<FullScreenCoverContent: View>: ViewModifier {
    
    @Binding var isPresented: Bool
    let onDismiss: (() -> Void)?
    let fullScreenCoverContent: () -> FullScreenCoverContent

    // Holds the latest preferences coming out of the sheet
    @State private var liftedPreferences: [ViewMetadata] = []
    
    func body(content: Content) -> some View {
        content
           .background {
                Color.clear
                    .preference(key: ViewMetadataKey.self, value: liftedPreferences)
            }
            .fullScreenCover(isPresented: $isPresented,
                             onDismiss: onDismiss,
                             content: {
                fullScreenCoverContent()
                    .onPreferenceChange(ViewMetadataKey.self) { liftedPreferences = $0 }
            })
            .onChange(of: isPresented) { newValue in
                 guard newValue == false else { return }
                       // cleaning after sheet is closed
                 liftedPreferences = []
            }
    }
}

private struct TrackingFullScreenCoverItemModifier<Item: Identifiable & Equatable, FullScreenCoverContent: View>: ViewModifier {
    
    @Binding var item: Item?
    let onDismiss: (() -> Void)?
    let fullScreenCoverContent: (Item) -> FullScreenCoverContent

    @State private var liftedPreferences: [ViewMetadata] = []

    @ViewBuilder
    func body(content: Content) -> some View {
        content
           // Re‑emit the sheet’s prefs onto the parent’s preference tree
            .background {
                Color.clear
                    .preference(key: ViewMetadataKey.self, value: liftedPreferences)
            }
            .fullScreenCover(item: $item,
                             onDismiss: onDismiss,
                             content: { item in
                fullScreenCoverContent(item)
                    .onPreferenceChange(ViewMetadataKey.self) { liftedPreferences = $0 }
            })
            .onChange(of: item) { newValue in
                guard newValue == nil else { return }
                // cleaning after sheet is closed
                liftedPreferences = []
            }
    }
}
