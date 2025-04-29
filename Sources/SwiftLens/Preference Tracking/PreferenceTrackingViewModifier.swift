//
//  SwiftUIView.swift
//  SwiftLens
//
//  Created by Karin Prater on 29/04/2025.
//

import SwiftUI

extension View {
    public func preferenceTracking(identifier: String,
                  viewName: String,
                  info: [String: AnyHashable] = [:]) -> some View {
        let viewType = String(describing: Self.self)  // `Self` here is the *concrete* view type you call this on
        return modifier(ViewMetadataModifier(viewName: viewName,
                                             viewType: viewType,
                                             identifier: identifier,
                                             info: info))
    }
    
    //TODO: make this useful and test
    public func transformPreferenceTracking(identifier: String,
                                            viewName: String,
                                            info: [String: AnyHashable] = [:]) -> some View  {
        self.transformPreference(ViewMetadataKey.self) { metadata in
            let viewType = String(describing: Self.self)
            metadata = [
                ViewMetadata(viewName: viewName,
                                 viewType: viewType,
                                 identifier: identifier,
                                 info: info,
                                 children: metadata)
            ]
        }
        
    }
}
