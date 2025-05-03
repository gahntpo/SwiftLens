//
//  SwiftUIView.swift
//  SwiftLens
//
//  Created by Karin Prater on 02/05/2025.
//

/// Presents a sheet and lifts its ViewMetadata preferences up to the
/// parent so that UIObservationLens can see them.

/*
 // MARK: isPresented-style
 .liftingSheet(isPresented: $showLogin) {
     LoginView()
 }

 // or with onDismiss:
 .liftingSheet(isPresented: $showLogin, onDismiss: { viewModel.reset() }) {
     LoginView()
 }

 // MARK: item-style
 .liftingSheet(item: $selectedUser) { user in
     UserDetail(user: user)
 }

 // or with onDismiss:
 .liftingSheet(item: $selectedUser, onDismiss: clearSelection) { user in
     UserDetail(user: user)
 }
 */


import SwiftUI

extension View {
   public func trackingSheet<Content: View>(
        isPresented: Binding<Bool>,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        modifier(TrackingSheetIsPresentedModifier(isPresented: isPresented,
                                        onDismiss: onDismiss,
                                        sheetContent: content))
    }
    
   public func trackingSheet<Item: Identifiable & Equatable, Content: View>(
          item: Binding<Item?>,
          onDismiss: (() -> Void)? = nil,
          @ViewBuilder content: @escaping (Item) -> Content
      ) -> some View {
          modifier(
              TrackingSheetItemModifier(
                  item: item,
                  onDismiss: onDismiss,
                  sheetContent: content
              )
          )
      }
}

/// A view modifier that presents a sheet but also captures any
/// ViewMetadata emitted by the sheet’s content and re‑publishes it
/// on the parent view’s ViewMetadataKey.
///
struct TrackingSheetIsPresentedModifier<SheetContent: View>: ViewModifier {
    
    @Binding var isPresented: Bool
    let onDismiss: (() -> Void)?
    let sheetContent: () -> SheetContent

    // Holds the latest preferences coming out of the sheet
    @State private var liftedPreferences: [ViewMetadata] = []
    
    
    /*
     Recipe: preferences from content view and sheet are added on same level, one after the other
     Text("six")
         .preferenceTracking(
             identifier: "six",
             viewName: "DemoContainerView"
         )
         .background {
             Color.clear
                 .preferenceTracking(
                     identifier: "six - background",
                     viewName: "DemoContainerView"
                 )
         }
     */
    
    
    func body(content: Content) -> some View {
        content
            .background {
                Color.clear
                    .preference(key: ViewMetadataKey.self, value: liftedPreferences)
            }
            .sheet(isPresented: $isPresented,
                   onDismiss: onDismiss) {
                sheetContent()
                    .onPreferenceChange(ViewMetadataKey.self) { liftedPreferences = $0 }
            }
            .onChange(of: isPresented) { newValue in
                 guard newValue == false else { return }
                       // cleaning after sheet is closed
                 liftedPreferences = []
            }
    }
}


private struct TrackingSheetItemModifier<Item: Identifiable & Equatable, SheetContent: View>: ViewModifier {
    
    @Binding var item: Item?
    let onDismiss: (() -> Void)?
    let sheetContent: (Item) -> SheetContent

    @State private var liftedPreferences: [ViewMetadata] = []

    @ViewBuilder
    func body(content: Content) -> some View {
        
        content
           // Re‑emit the sheet’s prefs onto the parent’s preference tree
            .background {
                Color.clear
                    .preference(key: ViewMetadataKey.self, value: liftedPreferences)
            }
           // The actual sheet
            .sheet(item: $item, onDismiss: onDismiss) { sheetItem in
                sheetContent(sheetItem)
                // Listen for changes in the sheet’s preferences
                    .onPreferenceChange(ViewMetadataKey.self) { liftedPreferences = $0 }
            }
           // .onChange(of: item) { oldValue, newValue in
            .onChange(of: item) { newValue in
                guard newValue == nil else { return }
                // cleaning after sheet is closed
                liftedPreferences = []
            }
    }
}
