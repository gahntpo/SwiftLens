//
//  File.swift
//  SwiftLens
//
//  Created by Karin Prater on 16/05/2025.
//

/*
 example use
 final class WaitTests: XCTestCase {

    @MainActor
     func testExample() async throws{
         // ---- SYSTEM ----
         let service = MockFetcherService()
         let vm = ProductFetcher(service: service)
         
         // ---- WHEN ----
         Task {
             await vm.loadProducts()
         }
         // ---- THEN ----
         await XCTWaitUntil(vm.$products, message: "no products found") { products in
             products.count > 0
         }
         
         XCTAssert(vm.state == .idle)
         XCTAssert(vm.products.count > 0)
     }
 }
 */

import XCTest
import Combine

extension XCTestCase {
   public func XCTWaitUntil<T: Equatable>(
        _ publisher: Published<T>.Publisher,
        timeout: TimeInterval = 1.0,
        message: String,
        condition: @escaping (T) -> Bool,
        file: StaticString = #file,
        line: UInt = #line
    ) async {
        do {
            try await publisher.waitUntilMatches(condition,
                                                 errorMessage: message,
                                                 timeout: timeout)
        } catch {
            XCTFail("waitUntilMatches failed: \(error)",
                    file: file,
                    line: line)
        }
    }
}
