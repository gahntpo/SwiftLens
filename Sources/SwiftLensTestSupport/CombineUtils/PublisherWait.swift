//
//
//  Created by Karin Prater on 23/04/2025.
//


//
//  PublisherWait.swift
//
//  Created for test utilities used in Swift Concurrency + Combine-based architectures.
//  Provides a simple way to wait for @Published properties to reach a target value
//  or fail after a timeout.
//
//  Usage:
//    try await viewModel.$isLoading.waitUntilMatches(false, errorMessage: "view model did not load",timeout: 1)
//    try await coordinator.$shownScreens.waitUntilMatches([], errorMessage: "navigation stack screens should be empty", timeout: 0.5)
//    try await lens.$values.waitUntilMatches { $0.containsView(with: "text.toggled.visible", errorMessage: "view not visible wiith id -...") }
//
//    let value = try await $values.waitUntilMatches(
//          { $0.value(for: "slider.volume", key: "value") as? Float == 0.5 },
//           errorMessage: "Expected slider.volume to be 0.5"
//    )

//  Only works with @Published<Value> where Value: Equatable.
//
//  Throws:
//    - TestTimeoutError if the value does not match the target within the timeout.
//
//  Note:
//    This should only be used in test targets. Do not use in production code.
//

import Foundation
import Combine

extension Published.Publisher where Value: Equatable {
  public func waitUntilMatches(
         _ target: Value,
         errorMessage: String,
         timeout: TimeInterval = 1.0
     ) async throws {
         try await self.waitUntilMatches({ $0 == target },
                                         errorMessage: errorMessage,
                                         timeout: timeout)
     }
    
  public func waitUntilMatches(
        _ predicate: @escaping (Value) -> Bool,
        errorMessage: String,
        timeout: TimeInterval = 1.0
    ) async throws {
        let subject = PassthroughSubject<Value, Error>()
        var cancellables = Set<AnyCancellable>()
        
        let timeoutPublisher = Fail<Value, Error>(error: WaitUntilError.timeout(description: errorMessage))
            .delay(for: .seconds(timeout), scheduler: RunLoop.main)
            .eraseToAnyPublisher()
            
        let valuePublisher = self
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
        
        valuePublisher
            .merge(with: timeoutPublisher)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    subject.send(completion: .failure(error))
                }
            }, receiveValue: { value in
                if predicate(value) {
                    subject.send(value)
                    subject.send(completion: .finished)
                }
            })
            .store(in: &cancellables)
        
       
        for try await _ in subject.values {}
    }
}


public struct TestTimeoutError: Error, Equatable {}

public enum WaitUntilError: Error, CustomStringConvertible, Equatable {
    case timeout(description: String)
    
    public var description: String {
        switch self {
            case .timeout(let message):
                return "⏰ Timeout: \(message)"
        }
    }
}


