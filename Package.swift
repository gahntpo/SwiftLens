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
    dependencies: [
        .package(url: "https://github.com/nalexn/ViewInspector.git", from: "0.10.1"),
    ],
    targets: [
        .target(
            name: "SwiftLens",
            swiftSettings: [
                .unsafeFlags(["-swift-version", "5.5"])
            ]),
        .target(
            name: "SwiftLensTestSupport",
            dependencies: [
                "SwiftLens",  // Test support depends on main
                .product(name: "ViewInspector", package: "ViewInspector")
            ],
            path: "Sources/SwiftLensTestSupport"  // different folder!
        ),
        .testTarget(
            name: "SwiftLensTests",
            dependencies: [
                "SwiftLens",
                "SwiftLensTestSupport",
                .product(name: "ViewInspector", package: "ViewInspector")
            ],
            swiftSettings: [
                .unsafeFlags(["-swift-version", "5.5"])
            ]
        ),
    ]
)
