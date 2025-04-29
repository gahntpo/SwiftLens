//
//  UIExpectations.swift
//  UserInteractionSimulationProjectTests
//
//  Created by Karin Prater on 28/04/2025.
//

import Foundation
import SwiftLens

final class UIObservationLens: ObservableObject {
    
    @Published var values: [ViewMetadata] = []

    //MARK: - sync
    
    func containsView(withID id: String) -> Bool {
        values.containsView(withID: id)
    }
    
    public func containsNotView(withID id: String) -> Bool {
        values.containsNotView(withID: id)
    }
    
    func viewCountWithViewID(prefix: String) -> Int {
        values.filter { $0.identifier.hasPrefix(prefix) }.count
    }
    
    func value(forViewID id: String, key: String) -> AnyHashable? {
        values.value(forViewID: id, key: key)
    }
    
    func enabledState(forViewID id: String) -> Bool? {
        values.value(forViewID: id, key: "isEnabled") as? Bool
    }
    
    func isEnabledState(forViewID id: String) -> Bool {
        enabledState(forViewID: id) == true
    }
    
    func isDisabledState(forViewID id: String) -> Bool {
        enabledState(forViewID: id) == false
    }
    
    func toggleState(forViewID id: String) -> Bool? {
        values.value(forViewID: id, key: "value") as? Bool
    }
    
    func isToggleOn(forViewID id: String) -> Bool {
        toggleState(forViewID: id) == true
    }
    
    func isToggleOff(forViewID id: String) -> Bool {
        toggleState(forViewID: id) == false
    }
    
    func textFieldFocus(forViewID id: String) -> Bool? {
        values.value(forViewID: id, key: "focused") as? Bool
    }
    
    func textFieldText(forViewID id: String) -> String? {
        values.value(forViewID: id, key: "value") as? String
    }
    
    //MARK: - await
    
    func waitForViewVisible(withID id: String,
                            timeout: TimeInterval = 1.0) async throws {
        try await $values.waitUntilMatches(
            { $0.contains { $0.identifier == id } },
            errorMessage: "Expected view visible with identifier: \(id)",
            timeout: timeout
        )
    }

    func waitForViewHidden(withID id: String,
                           timeout: TimeInterval = 1.0) async throws {
        try await $values.waitUntilMatches(
            { $0.allSatisfy { $0.identifier != id } },
            errorMessage: "Expected view hidden with identifier: \(id)",
            timeout: timeout
        )
    }
    
    func waitForViewCount(WithViewIDPrefix: String,
                             expected: Int,
                             timeout: TimeInterval = 1.0) async throws  {
        try await $values.waitUntilMatches(
            { $0.filter( { $0.identifier.hasPrefix(WithViewIDPrefix)  }).count == expected },
            errorMessage: "Expected view visible with identifier prefix: \(WithViewIDPrefix) visible \(expected) times",
            timeout: timeout
        )
    }

    func waitForView(withID id: String,
                     hasValue expected: String,
                     timeout: TimeInterval = 1.0) async throws {
        try await $values.waitUntilMatches(
            { metas in
                guard let meta = metas.first(where: { $0.identifier == id }),
                      let actual = meta.info["value"] as? String else { return false }
                return actual == expected
            },
            errorMessage: "Expected value `\(expected)` for view with id: \(id)",
            timeout: timeout
        )
    }

    func waitForValue<T: Equatable>(forViewID: String,
                                    equals expected: T,
                                    timeout: TimeInterval = 1.0) async throws {
        try await $values.waitUntilMatches(
            { metas in
                guard let meta = metas.first(where: { $0.identifier == forViewID }),
                      let actual = meta.info["value"] as? T else { return false }
                return actual == expected
            },
            errorMessage: "Expected value `\(expected)` for view with id: \(forViewID)",
            timeout: timeout
        )
    }
    
    func waitForTextFieldFocused(withID id: String,
                                 isFocused: Bool,
                                 timeout: TimeInterval = 1.0) async throws {
        try await $values.waitUntilMatches(
            { $0.contains { $0.identifier == id  && ( $0.info["focused"] as? Bool ?? false == isFocused ) } },
            errorMessage: "Expected textfield focused with identifier: \(id) - \(isFocused ? "focused" : "not focused")",
            timeout: timeout
        )
    }
}
