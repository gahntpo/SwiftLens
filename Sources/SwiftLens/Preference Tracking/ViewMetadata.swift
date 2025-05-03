//
//  ViewMetadata.swift
//  UserInteractionSimulationProject
//
//  Created by Karin Prater on 23/04/2025.
//

import SwiftUI


public struct ViewMetadata: Equatable {
    
    public let viewName: String
    public let viewType: String
    public let identifier: String
    public let info: [String: AnyHashable]
    
    public var children: [ViewMetadata] = [] // use transformPreferences
    
    public init(viewName: String,
         viewType: String,
         identifier: String,
         info: [String : AnyHashable] = [:],
         children: [ViewMetadata] = []) {
        self.viewName = viewName
        self.viewType = viewType
        self.identifier = identifier
        self.info = info
        self.children = children
    }
    
}

extension ViewMetadata: CustomStringConvertible {
    public var description: String {
        // single‐line, concise:
        
        """
         \(viewName) { id: “\(identifier)”\(info.isEmpty ? "" : ", value: \(info)")\(children.isEmpty ? "" : ", children: \(children.map({ $0.identifier}))")}
         """
        
        // — or, for a multi‐line style, swap the above for this:
        /*
         """
         \(viewName).\(viewType)
         • id:        \(identifier)
         • value:     \(value)
         """
         */
    }
}

extension Array where Element == ViewMetadata {
    
    public func findView(withID id: String) -> ViewMetadata? {
         for meta in self {
             if meta.identifier == id {
                 return meta
             }
             if let foundInChildren = meta.children.findView(withID: id) {
                 return foundInChildren
             }
         }
         return nil
     }
    
    public func containsView(withID id: String) -> Bool {
        findView(withID: id) != nil
    }
    
    public func containsNotView(withID id: String) -> Bool {
         !containsView(withID: id)
     }
    
    public func value(forViewID id: String, key: String) -> AnyHashable? {
        findView(withID: id)?.info[key]
    }
    
    public func flattened() -> [ViewMetadata] {
        flatMap { [$0] + $0.children.flattened() }
    }
}

public struct ViewMetadataKey: PreferenceKey {
    public static var defaultValue: [ViewMetadata] = []
    
    public static func reduce(value: inout [ViewMetadata], nextValue: () -> [ViewMetadata]) {
        value.append(contentsOf: nextValue())
    }
}


