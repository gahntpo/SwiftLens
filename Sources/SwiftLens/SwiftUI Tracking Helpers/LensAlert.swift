//
//  SwiftUIView.swift
//  SwiftLens
//
//  Created by Karin Prater on 23/05/2025.
//

import SwiftUI

//TODO: optional arguments like .alert(isPresented: Binding<Bool>, content: () -> Alert)

/*
 nonisolated public func alert<A, T>(_ titleKey: LocalizedStringKey, isPresented: Binding<Bool>, presenting data: T?, @ViewBuilder actions: (T) -> A) -> some View where A : View
 
 .alert(isPresented: <#T##Binding<Bool>#>, error: <#T##LocalizedError?#>, actions: <#T##(LocalizedError) -> View#>, message: <#T##(LocalizedError) -> View#>)

 */

extension View {
    public func lensAlert<Actions: View, Message: View>(
        id: String,
        title: LocalizedStringKey,
        isPresented: Binding<Bool>,
        @ViewBuilder actions: @escaping () -> Actions,
        @ViewBuilder message: @escaping () -> Message
    ) -> some View {
        self.modifier(LensAlertModifier(accessibilityIdentifier: id,
                                        isPresented: isPresented,
                                        title: title,
                                        actions: actions,
                                        message: message))
    }
    
    public func lensAlert<T, Actions: View, Message: View>(
        id: String,
        title: LocalizedStringKey,
        isPresented: Binding<Bool>,
        presenting data: T?,
        @ViewBuilder actions: @escaping (T) -> Actions,
        @ViewBuilder message: @escaping (T) -> Message
    ) -> some View {
        self.modifier(
            LensAlertWithDataModifier(
                id: id,
                isPresented: isPresented,
                title: title,
                data: data,
                actions: actions,
                message: message)
            )
    }
    
    public func lensAlert<E: LocalizedError, Actions: View, Message: View>(
        id: String,
        isPresented: Binding<Bool>,
        error: E?,
        @ViewBuilder actions: @escaping (E) -> Actions,
        @ViewBuilder message: @escaping (E) -> Message
    ) -> some View {
        self.modifier(
            LensAlertWithErrorModifier(
                id: id,
                isPresented: isPresented,
                error: error,
                actions: actions,
                message: message
            )
        )
    }
    
}

/// A view modifier that presents an alert but also captures any
/// LensCapture emitted by the alert’s content and re‑publishes it
/// on the parent view’s LensCaptureKey.
///
public struct LensAlertModifier<Actions: View, Message: View>: ViewModifier {
    let accessibilityIdentifier: String
    @Binding var isPresented: Bool
    let title: LocalizedStringKey
    let actions: () -> Actions
    let message: () -> Message

    @State private var liftedPreferences: [LensCapture] = []

    var passedPreferences: [LensCapture] {
        guard isPresented else { return [] }
        guard !liftedPreferences.isEmpty else { return [] }
        
        return [
            LensCapture(viewType: String(describing: Self.self),
                        identifier: accessibilityIdentifier,
                        children: liftedPreferences)
        ]
    }

    public func body(content: Content) -> some View {
        content
            .background(Color.clear.preference(key: LensCaptureKey.self,
                                               value: passedPreferences))
            .alert(title,
                   isPresented: $isPresented,
                   actions: {
                actions()
                    .onPreferenceChange(LensCaptureKey.self) { liftedPreferences = $0
                    }
            }, message: {
                message()
            })
    }
}

//MARK: - Alert with Presenting Data

public struct LensAlertWithDataModifier<T, Actions: View, Message: View>: ViewModifier {
    let id: String
    @Binding var isPresented: Bool
    let title: LocalizedStringKey
    let data: T?
    let actions: (T) -> Actions
    let message: (T) -> Message
    
    @State private var capturedChildren: [LensCapture] = []

    var liftedCapture: [LensCapture] {
        guard isPresented else { return [] }
        return [
            LensCapture(
                viewType: "Alert",
                identifier: id,
                children: capturedChildren
            )
        ]
    }

    public func body(content: Content) -> some View {
        content
            .background(Color.clear.preference(key: LensCaptureKey.self, value: liftedCapture))
        
            .alert(title,
                   isPresented: $isPresented,
                   presenting: data,
                   actions: { data in
                    actions(data)
                
                    .onPreferenceChange(LensCaptureKey.self) {
                        //accumulates all children preferences
                        capturedChildren.append(contentsOf: $0.filter { !capturedChildren.contains($0) })

                    }
            },
                   message: message)
            .onChange(of: isPresented) { isPresented in
                guard !isPresented else { return }
                capturedChildren = []
            }
    }
}


//MARK: - Alert with Error

struct LensAlertWithErrorModifier<E: LocalizedError, Actions: View, Message: View>: ViewModifier {
    let id: String
    @Binding var isPresented: Bool
    let error: E?
    let actions: (E) -> Actions
    let message: (E) -> Message

    @State private var capturedChildren: [LensCapture] = []

    var liftedCapture: [LensCapture] {
        guard isPresented else { return [] }
        return [
            LensCapture(viewType: "Alert",
                        identifier: id,
                        children: capturedChildren)
        ]
    }

    public func body(content: Content) -> some View {
        content
            .background(Color.clear.preference(key: LensCaptureKey.self,
                                               value: liftedCapture))
            .alert(isPresented: $isPresented,
                   error: error,
                   actions: { error in
                actions(error)
                    .onPreferenceChange(LensCaptureKey.self) { capturedChildren = $0 }
            },
                   message: message)
    }
}
