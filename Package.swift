// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "HerbieFP",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .executable(name: "herbie-helper", targets: ["HerbieHelper"]),
        .library(name: "Herbie", targets: ["Herbie"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/apple/swift-nio.git",
            from: "2.66.0"),
        .package(
            url: "https://github.com/zaneenders/swift-fpcore.git",
            revision: "main"),
        .package(
            url: "https://github.com/swift-server/async-http-client.git",
            from: "1.9.0"),
    ],
    targets: [
        .target(
            name: "Herbie",
            dependencies: [
                .product(name: "_NIOFileSystem", package: "swift-nio"),
                .product(name: "AsyncHTTPClient", package: "async-http-client"),
            ]),
        .executableTarget(
            name: "HerbieHelper",
            dependencies: [
                "Herbie",
                .product(name: "_NIOFileSystem", package: "swift-nio"),
                .product(name: "FPCore", package: "swift-fpcore"),
                .product(name: "AsyncHTTPClient", package: "async-http-client"),
            ], swiftSettings: swiftSettings),
        .testTarget(
            name: "HerbieTests",
            dependencies: ["HerbieHelper"]),
    ]
)

// Swift 6 settings
let swiftSettings: [SwiftSetting] = [
    .enableUpcomingFeature("BareSlashRegexLiterals"),
    .enableUpcomingFeature("ConciseMagicFile"),
    .enableUpcomingFeature("ExistentialAny"),
    .enableUpcomingFeature("ForwardTrailingClosures"),
    .enableUpcomingFeature("ImplicitOpenExistentials"),
    .enableUpcomingFeature("StrictConcurrency"),
    .unsafeFlags([
        "-warn-concurrency", "-enable-actor-data-race-checks",
    ]),
]
