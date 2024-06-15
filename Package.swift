// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "HerbieFP",
    platforms: [
        .macOS(.v14),
        .iOS(.v16),
        .tvOS(.v16),
        .watchOS(.v8),
    ],
    products: [
        .executable(name: "herbie-helper", targets: ["HerbieHelper"]),
        .library(name: "Herbie", targets: ["Herbie"]),
    ],
    dependencies: [
        .package(
            url: "git@github.com:apple/swift-nio.git",
            from: "2.66.0"),
        .package(
            url: "git@github.com:zaneenders/ScribeSystem.git",
            revision: "fb0d944"),
        // .package(name: "ScribeSystem", path: "../ScribeSystem/"),
        .package(
            url: "git@github.com:zaneenders/fp-core.git", revision: "main"),
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
                .product(name: "ScribeSystem", package: "ScribeSystem"),
                .product(name: "_NIOFileSystem", package: "swift-nio"),
                .product(name: "FPCore", package: "fp-core"),
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
