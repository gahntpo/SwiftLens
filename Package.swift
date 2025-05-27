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
            swiftSettings: [
                .unsafeFlags(["-swift-version", "5.5"])
            ]
        ),
        .target(
            name: "SwiftLensTestSupport",
            dependencies: ["SwiftLens"],
            path: "Sources/SwiftLensTestSupport"
        ),
        .testTarget(
            name: "SwiftLensTests",
            dependencies: ["SwiftLens", "SwiftLensTestSupport"],
            swiftSettings: [
                .unsafeFlags(["-swift-version", "5.5"])
            ]
        )
    ]
)

