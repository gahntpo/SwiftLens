//
//  Test.swift
//  SwiftLens
//
//  Created by Karin Prater on 28/05/2025.
//

import Foundation
import Testing
@testable import SwiftLensTestSupport
import SwiftUI

struct SnapshotTests {

    @MainActor
    @Test("Snapshot saves files to disk")
    func snapshot_saves_expected_files() async throws {
        
        let sut = LensWorkBench { sut in
            Text("Hello World")
        }
        
        let namePrefix = "TestSnapshot"
        sut.saveSnapshotToDisk(name: namePrefix) // will internally add a UUID
        
        let tempDir = FileManager.default.temporaryDirectory
        let contents = try FileManager.default.contentsOfDirectory(atPath: tempDir.path)
        
        // Match files like: TestSnapshot_<alphanumeric>.ext
        let pattern = "^" + NSRegularExpression.escapedPattern(for: namePrefix) + "_[A-Z0-9]{8}\\.(png|txt|plist)$"
        let regex = try NSRegularExpression(pattern: pattern)
        
        let matchingFiles = contents.filter { file in
            regex.firstMatch(in: file, range: NSRange(location: 0, length: file.count)) != nil
        }
        
        let expectedExtensions = ["png", "txt", "plist"]
        for ext in expectedExtensions {
            let found = matchingFiles.contains { $0.hasSuffix(".\(ext)") }
            #expect(found, "Missing snapshot file with extension .\(ext)")
        }
    }
}
