//
//  LensObserver.swift
//
//  Created by Karin Prater on 28/04/2025.
//

import SwiftUI
import SwiftLens

public
final class LensObserver: ObservableObject {
    
    @Published public var values: [LensCapture] = []
    
   public func printValues() {
       print("---- Values ---")
       _ = values.map { print("- " + $0.description )}
       print("---------------")
    }

    //MARK: - sync
    
    public func view(withID id: String) -> LensCapture? {
        values.findView(withID: id)
    }
    
    public func containsView(withID id: String) -> Bool {
        values.containsView(withID: id)
    }
    
    public func containsNotView(withID id: String) -> Bool {
        values.containsNotView(withID: id)
    }
    
    public func containsNotView(withIDPrefix: String) -> Bool {
        viewCount(withIDPrefix: withIDPrefix) == 0
    }
    
    public func containsView(withIDPrefix: String) -> Bool {
        viewCount(withIDPrefix: withIDPrefix) > 1
    }
    
    public func viewCount(withIDPrefix: String) -> Int {
        values.flattened().filter { $0.identifier.hasPrefix(withIDPrefix) }.count
    }
    
    public func value(forViewID id: String, key: String) -> AnyHashable? {
        values.value(forViewID: id, key: key)
    }
    
    public func hasInfo<T: Equatable>(forViewID id: String,
                                       in key: String = "value",
                                       equalTo target: T) -> Bool {
        values.value(forViewID: id, key: key) as? T == target
    }
    
    public func enabledState(forViewID id: String) -> Bool? {
        values.value(forViewID: id, key: "isEnabled") as? Bool
    }
    
    public func isEnabledState(forViewID id: String) -> Bool {
        enabledState(forViewID: id) == true
    }
    
    public func isDisabledState(forViewID id: String) -> Bool {
        enabledState(forViewID: id) == false
    }
    
    public func isButton(forViewID id: String,
                         role: ButtonRole?) -> Bool {
        guard let roleRawValue = values.value(forViewID: id, key: "role") as? Int else {
            return false
        }
        
        switch role {
            case .cancel: return roleRawValue == 4
            case .destructive: return roleRawValue == 1
            default: return roleRawValue == 0
                
        }
    }
    
    public func toggleState(forViewID id: String) -> Bool? {
        values.value(forViewID: id, key: "value") as? Bool
    }
    
    public func isToggleOn(forViewID id: String) -> Bool {
        toggleState(forViewID: id) == true
    }
    
    public func isToggleOff(forViewID id: String) -> Bool {
        toggleState(forViewID: id) == false
    }
    
    public func textFieldFocus(forViewID id: String) -> Bool? {
        values.value(forViewID: id, key: "focused") as? Bool
    }
    
    public func textFieldText(forViewID id: String) -> String? {
        values.value(forViewID: id, key: "value") as? String
    }
    
    public func textFieldText(forViewID id: String, equalTo text: String) -> Bool {
        textFieldText(forViewID: id) == text
    }
    
    //MARK: - await
    
    public func waitForViewVisible(withID id: String,
                            timeout: TimeInterval = 1.0) async throws {
        try await $values.waitUntilMatches(
            { $0.containsView(withID: id) },
            errorMessage: "Expected view visible with identifier: \(id)",
            timeout: timeout
        )
    }

    public func waitForViewHidden(withID id: String,
                           timeout: TimeInterval = 1.0) async throws {
        try await $values.waitUntilMatches(
            { !$0.containsView(withID: id) },
            errorMessage: "Expected view hidden with identifier: \(id)",
            timeout: timeout
        )
    }
    
    public func waitForViewCount(withViewIDPrefix: String,
                             expected: Int,
                             timeout: TimeInterval = 1.0) async throws  {
        try await $values.waitUntilMatches(
            {
                $0.flattened().filter { $0.identifier.hasPrefix(withViewIDPrefix) }.count == expected
            },
            errorMessage: "Expected view visible with identifier prefix: '\(withViewIDPrefix)' visible \(expected) times but found \(self.viewCount(withIDPrefix: withViewIDPrefix))",
            timeout: timeout
        )
    }

    public func waitForView(withID id: String,
                     hasValue expected: String,
                     timeout: TimeInterval = 1.0) async throws {
        try await $values.waitUntilMatches(
            { $0.findView(withID: id)?.info["value"] as? String == expected },
            errorMessage: "Expected value `\(expected)` for view with id: \(id)",
            timeout: timeout
        )
    }

    public func wait<T: Equatable>(forViewID id: String,
                                    infoKey: String = "value",
                                    equals expected: T,
                                   errorMessage: String? = nil,
                                    timeout: TimeInterval = 1.0) async throws {
        try await $values.waitUntilMatches(
            { $0.findView(withID: id)?.info[infoKey] as? T == expected },
            errorMessage: errorMessage ?? "Expected value `\(expected)` for view with id: \(id)",
            timeout: timeout
        )
    }
    
    public func waitForValue<T: Equatable>(forViewID id: String,
                                    equals expected: T,
                                    timeout: TimeInterval = 1.0) async throws {
        try await $values.waitUntilMatches(
            { $0.findView(withID: id)?.info["value"] as? T == expected },
            errorMessage: "Expected value `\(expected)` for view with id: \(id)",
            timeout: timeout
        )
    }
    
    public func waitForTextFieldFocused(withID id: String,
                                 isFocused: Bool,
                                 timeout: TimeInterval = 1.0) async throws {
        try await $values.waitUntilMatches(
            { $0.findView(withID: id)?.info["focused"] as? Bool == isFocused  },
            errorMessage: "Expected textfield focused with identifier: \(id) - \(isFocused ? "focused" : "not focused")",
            timeout: timeout
        )
    }
    

    
    public func waitButton(forViewID id: String, isEnabled: Bool)  async throws  {
        try await wait(forViewID: id,
                               infoKey: "isEnabled",
                       equals: isEnabled, errorMessage: "Expected that Button \(id) should be \(isEnabled ? "enabled" : "disabled")")
    }
}
