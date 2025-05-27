//
//  SwiftUIView.swift
//  SwiftLens
//
//  Created by Karin Prater on 29/04/2025.
//

import SwiftUI

extension View {
    public func lensTracked(id: String,
                            info: [String: AnyHashable] = [:]) -> some View {
        self.preference(key: LensCaptureKey.self,
                        value: [LensCapture(viewType: String(describing: Self.self),
                                             identifier: id,
                                             info: info)])
        .accessibilityIdentifier(id)
    }
    
    public func lensGroup(id: String,
                          info: [String: AnyHashable] = [:]) -> some View  {
        self.transformPreference(LensCaptureKey.self) { metadata in
            metadata = [
                LensCapture(viewType: String(describing: Self.self),
                             identifier: id,
                             info: info,
                             children: metadata)
            ]
        }
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier(id)
    }
}
