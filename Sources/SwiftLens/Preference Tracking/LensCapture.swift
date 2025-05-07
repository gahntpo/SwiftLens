//
//  LensCapture.swift
//  UserInteractionSimulationProject
//
//  Created by Karin Prater on 23/04/2025.
//

import SwiftUI


public struct LensCapture: Equatable {
    
    public let viewType: String
    public let identifier: String
    public var info: [String: AnyHashable]
    
    public var children: [LensCapture] = [] // use transformPreferences
    
    public init(viewType: String,
         identifier: String,
         info: [String : AnyHashable] = [:],
         children: [LensCapture] = []) {
        self.viewType = viewType
        self.identifier = identifier
        self.info = info
        self.children = children
    }
    
}

extension LensCapture: CustomStringConvertible {
    public var description: String {
        """
         \(viewType) { id: “\(identifier)”\(info.isEmpty ? "" : ", value: \(info)")\(children.isEmpty ? "" : ", children: \(children.map({ $0.identifier}))")}
         """
    }
}

extension Array where Element == LensCapture {
    
    public func findView(withID id: String) -> LensCapture? {
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
    
    public func flattened() -> [LensCapture] {
        flatMap { [$0] + $0.children.flattened() }
    }
}

public struct LensCaptureKey: PreferenceKey {
    public static var defaultValue: [LensCapture] = []
    
    public static func reduce(value: inout [LensCapture], nextValue: () -> [LensCapture]) {
        value.append(contentsOf: nextValue())
    }
}


