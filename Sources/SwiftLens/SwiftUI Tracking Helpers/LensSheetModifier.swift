//
//  SwiftUIView.swift
//  SwiftLens
//
//  Created by Karin Prater on 02/05/2025.
//

/// Presents a sheet and lifts its LensCapture preferences up to the
/// parent so that UIObservationLens can see them.

/*
 // MARK: isPresented-style
 .lensSheet(isPresented: $showLogin) {
     LoginView()
 }

 // or with onDismiss:
 .lensSheet(isPresented: $showLogin, onDismiss: { viewModel.reset() }) {
     LoginView()
 }

 // MARK: item-style
 .lensSheet(item: $selectedUser) { user in
     UserDetail(user: user)
 }

 // or with onDismiss:
 .lensSheet(item: $selectedUser, onDismiss: clearSelection) { user in
     UserDetail(user: user)
 }
 */


import SwiftUI

extension View {
    public func lensSheet<Content: View>(
        id: String,
        isPresented: Binding<Bool>,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        modifier(
            LensSheetIsPresentedModifier(accessibilityIdentifier: id,
                                         isPresented: isPresented,
                                         onDismiss: onDismiss,
                                         sheetContent: content))
    }
    
    public func lensSheet<Item: Identifiable & Equatable, Content: View>(
        id: String,
        item: Binding<Item?>,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping (Item) -> Content
    ) -> some View {
        modifier(
            LensSheetItemModifier(accessibilityIdentifier: id,
                                  item: item,
                                  onDismiss: onDismiss,
                                  sheetContent: content)
        )
    }
}

/// A view modifier that presents a sheet but also captures any
/// LensCapture emitted by the sheet’s content and re‑publishes it
/// on the parent view’s LensCaptureKey.
///
struct LensSheetIsPresentedModifier<SheetContent: View>: ViewModifier {
    
    public let accessibilityIdentifier: String
    @Binding var isPresented: Bool
    let onDismiss: (() -> Void)?
    let sheetContent: () -> SheetContent

    // Holds the latest preferences coming out of the sheet
    @State private var liftedPreferences: [LensCapture] = []
    
    var passedPreferences: [LensCapture] {
        guard isPresented else { return [] }
        guard !liftedPreferences.isEmpty else { return [] }
        
        return [LensCapture(viewType: String(describing: Self.self),
                            identifier: accessibilityIdentifier,
                            children: liftedPreferences)]
    }
    /*
     Recipe: preferences from content view and sheet are added on same level, one after the other
     Text("six")
         .lensTracked(id: "six")
         .background {
             Color.clear
                .lensTracked(id:"six - background")
         }
     */
    
    
    func body(content: Content) -> some View {
        content
            .background {
                Color.clear
                    .preference(key: LensCaptureKey.self,
                                value: passedPreferences)
            }
            .sheet(isPresented: $isPresented,
                   onDismiss: onDismiss) {
                sheetContent()
                    .onPreferenceChange(LensCaptureKey.self) { liftedPreferences = $0 }
            }
    }
}


private struct LensSheetItemModifier<Item: Identifiable & Equatable, SheetContent: View>: ViewModifier {
    
    public let accessibilityIdentifier: String
    @Binding var item: Item?
    let onDismiss: (() -> Void)?
    let sheetContent: (Item) -> SheetContent

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
           // The actual sheet
            .sheet(item: $item, onDismiss: onDismiss) { sheetItem in
                sheetContent(sheetItem)
                // Listen for changes in the sheet’s preferences
                    .onPreferenceChange(LensCaptureKey.self) { liftedPreferences = $0 }
            }
    }
}
