//
//  File.swift
//  SwiftLens
//
//  Created by Karin Prater on 28/05/2025.
//

import SwiftLens
#if os(iOS) || os(visionOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

extension LensWorkBench {
    
    /// 📸 Saving a snapshot of the current UI state to disk
    ///
    /// This includes:
    /// - A screenshot of the visible window (`UIImage`/`NSImage`).
    /// - A `.plist` file representing the captured view hierarchy (`LensCapture`).
    /// - A `.txt` dump of the same hierarchy for human-readable inspection.
    ///
    /// Useful for debugging failed expectations, layout issues, or unexpected state.
    ///
    /// ⚠️ **Performance Note:**
    /// Taking a screenshot and serialising the hierarchy can significantly increase test execution time
    /// (e.g. from 0.1s to 0.3–0.5s per use). Prefer to use this **only when necessary**, such as:
    ///
    /// - Parameters:
    ///   - name: Used as the base name for all attachments (screenshot + hierarchy).
    ///
    @MainActor
    public func saveSnapshotToDisk(name: String = "DebugSnapshot") {
        // make sure file names are unique
        let safeName = SnapshotNamer.withUUID(base: name)
        
        // Save Screenshot
        if let image = window.asImage(),
           let data = image.pngData() {
            let screenshotPath = FileManager.default.temporaryDirectory.appendingPathComponent("\(safeName).png")
            try? data.write(to: screenshotPath)
            print("📸 Saved screenshot to: \(screenshotPath.path)")
        }

        // Save Property List
        if let data = observer.propertyListData() {
            let plistPath = FileManager.default.temporaryDirectory.appendingPathComponent("\(safeName).plist")
            try? data.write(to: plistPath)
            print("Saved hierarchy plist to: \(plistPath.path)")
        }

        // Save Text Dump
        let dumpPath = FileManager.default.temporaryDirectory.appendingPathComponent("\(safeName).txt")
        let text = observer.hierarchyTextDump()
        try? text.write(to: dumpPath, atomically: true, encoding: .utf8)
        print("Saved hierarchy dump to: \(dumpPath.path)")
    }
}


public enum SnapshotNamer {
    
    /// Generates a safe filename using a base name and UUID
    public static func withUUID(base: String) -> String {
        let unique = UUID().uuidString.prefix(8)
        return "\(base)_\(unique)"
    }

    /// Generates a filename with current date/time (useful for manual inspection)
    public static func withTimestamp(base: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd_HH-mm-ss"
        let dateString = formatter.string(from: Date())
        return "\(base)_\(dateString)"
    }
}

#if os(iOS) || os(visionOS)
extension UIWindow {
    func asImage() -> UIImage? {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { context in
            layer.render(in: context.cgContext)
        }
    }
}
#elseif os(macOS)
extension NSWindow {
    func asImage() -> NSImage? {
        guard let contentView = contentView else { return nil }
        let image = NSImage(size: contentView.frame.size)
        image.lockFocus()
        if let context = NSGraphicsContext.current?.cgContext {
            contentView.layer?.render(in: context)
        }
        image.unlockFocus()
        return image
    }
}

extension NSImage {
    /// Mirrors `UIImage.pngData()` so screenshot code can be shared across platforms.
    func pngData() -> Data? {
        guard let tiff = tiffRepresentation,
              let bitmap = NSBitmapImageRep(data: tiff) else { return nil }
        return bitmap.representation(using: .png, properties: [:])
    }
}
#endif

//MARK: - converting LensCapture to file content

public struct LensCaptureCodable: Codable {
    let viewType: String
    let identifier: String
    let info: [String: String]
    let children: [LensCaptureCodable]
    
    init(from capture: LensCapture) {
        self.viewType = capture.viewType
        self.identifier = capture.identifier
        self.info = capture.info.mapValues { "\($0)" }
        self.children = capture.children.map(LensCaptureCodable.init)
    }
}

extension LensObserver {
    
    public func propertyListData() -> Data? {
        do {
            let codableHierarchy = values.map { LensCaptureCodable(from: $0) }
            return try PropertyListEncoder().encode(codableHierarchy)
        } catch {
            print("Failed to encode LensObserver values to plist: \(error)")
            return nil
        }
    }
    
    public func hierarchyTextDump() -> String {
        func describe(_ capture: LensCapture, prefix: String = "", isLast: Bool = true) -> [String] {
            let bullet = isLast ? "└─" : "├─"
            var lines: [String] = ["\(prefix)\(bullet) \(capture.identifier)"]
            
            for (key, value) in capture.info.sorted(by: { $0.key < $1.key }) {
                lines.append("\(prefix)\(isLast ? "   " : "│  ")  • \(key): \(value)")
            }
            
            let childPrefix = prefix + (isLast ? "   " : "│  ")
            for (index, child) in capture.children.enumerated() {
                let isLastChild = index == capture.children.count - 1
                lines.append(contentsOf: describe(child, prefix: childPrefix, isLast: isLastChild))
            }
            
            return lines
        }
        
        var output: [String] = [
            "📋 Lens Hierarchy Dump",
            String(repeating: "=", count: 40),
            ""
        ]
        
        for (index, root) in values.enumerated() {
            let isLast = index == values.count - 1
            output.append(contentsOf: describe(root, isLast: isLast))
            output.append("")
        }
        
        return output.joined(separator: "\n")
    }
}
