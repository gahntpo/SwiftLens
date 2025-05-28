//
//  LensWorkBench+XCTestAttachments.swift
//  SwiftLens
//
//  Created by Karin Prater on 28/05/2025.
//

import XCTest
import SwiftLens

extension LensWorkBench {
    /// XCTest improve debugging.
    /// 🧩 Attaches only the view hierarchy of the current UI — no screenshot.
    ///
    /// Includes:
    /// - A `.plist` file of the LensCapture structure
    /// - A `.txt` version for readable debugging
    ///
    /// ⚠️ Faster than full snapshot, but still has serialization cost. Use during complex UI failures
    /// or when the structure of views is more important than their visual layout.
    ///
    /// - Parameters:
    ///   - name: Used as base name for all hierarchy-related attachments.
    ///   - lifetime: `.keepAlways` by default; can be `.deleteOnSuccess` for CI.
    @MainActor
    public func attachViewHierarchyToXCTest(name: String = "Screenshot",
                                    lifetime: XCTAttachment.Lifetime = .keepAlways,
                                    file: StaticString = #file,
                                    line: UInt = #line) {
        let hierarchyDump = observer.propertyListData() ?? Data()
        let hierarchyAttachment = XCTAttachment(data: hierarchyDump, uniformTypeIdentifier: "com.apple.property-list")
        hierarchyAttachment.name = "\(name) - LensObserver Hierarchy"
        hierarchyAttachment.lifetime = lifetime
        
        let textDump = observer.hierarchyTextDump()
        let texAttachment = XCTAttachment(string: textDump)
        texAttachment.name = "\(name) - LensObserver Hierarchy"
        texAttachment.lifetime = lifetime
        
        XCTContext.runActivity(named: name) { activity in
            activity.add(hierarchyAttachment)
            activity.add(texAttachment)
        }
    }
    
    /// 📸 Attaches a snapshot of the current UI state to the test result.
    ///
    /// This includes:
    /// - A screenshot of the visible window (`UIImage`).
    /// - A `.plist` file representing the captured view hierarchy (`LensCapture`).
    /// - A `.txt` dump of the same hierarchy for human-readable inspection.
    ///
    /// Useful for debugging failed expectations, layout issues, or unexpected state.
    ///
    /// ⚠️ **Performance Note:**
    /// Taking a screenshot and serialising the hierarchy can significantly increase test execution time
    /// (e.g. from 0.1s to 0.3–0.5s per use). Prefer to use this **only when necessary**, such as:
    /// - In `onFailure` callbacks during `waitFor...`
    /// - Wrapped in conditionals for failed expectations
    ///
    /// Example usage (on failure):
    /// ```swift
    /// try await sut.observer.waitForViewVisible(withID: "buy.button")
    /// // If failure handler is set, snapshot will be captured automatically
    /// ```
    ///
    /// - Parameters:
    ///   - name: Used as the base name for all attachments (screenshot + hierarchy).
    ///   - lifetime: `XCTAttachment.Lifetime`, defaults to `.keepAlways` for visibility in passed tests.
    ///   - file: Automatically captures the file for XCTFail fallback.
    ///   - line: Automatically captures the line for XCTFail fallback.
    @MainActor
    public func attachSnapshotToXCTest(name: String = "Screenshot",
                               lifetime: XCTAttachment.Lifetime = .keepAlways,
                               file: StaticString = #file,
                               line: UInt = #line) {
        guard let image = window.asImage() else {
            XCTFail("Failed to capture screenshot", file: file, line: line)
            return
        }

        let screenshotAttachment = XCTAttachment(image: image)
        screenshotAttachment.name = "Screenshot"
        screenshotAttachment.lifetime = lifetime
        
        let hierarchyDump = observer.propertyListData() ?? Data()
        let hierarchyAttachment = XCTAttachment(data: hierarchyDump, uniformTypeIdentifier: "com.apple.property-list")
        hierarchyAttachment.name = "LensObserver View Hierarchy"
        hierarchyAttachment.lifetime = lifetime
        
        let textDump = observer.hierarchyTextDump()
        let texAttachment = XCTAttachment(string: textDump)
        texAttachment.name = "LensObserver View Hierarchy"
        texAttachment.lifetime = lifetime
        
        XCTContext.runActivity(named: name) { activity in
            activity.add(screenshotAttachment)
            activity.add(hierarchyAttachment)
            activity.add(texAttachment)
        }
    }
}
