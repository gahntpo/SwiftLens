// swift-tools-version: 5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftLens",
    platforms: [.iOS(.v15), .macOS(.v12)],
    products: [
        .library(name: "SwiftLens", targets: ["SwiftLens"]),
        .library(name: "SwiftLensTestSupport", targets: ["SwiftLensTestSupport"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SwiftLens",
            linkerSettings: [
                .linkedFramework("SwiftUI"),
            ]
        ),
        .target(
            name: "SwiftLensTestSupport",
            dependencies: ["SwiftLens"],
            path: "Sources/SwiftLensTestSupport",
            linkerSettings: [
                .linkedFramework("SwiftUI"),
            ]
        ),
        .testTarget(
            name: "SwiftLensTests",
            dependencies: ["SwiftLens", "SwiftLensTestSupport"]
        ),
    ]
)
