// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "HerbieFP",
    platforms: [
        .macOS(.v13),
        .iOS(.v16),
        .tvOS(.v16),
        .watchOS(.v8),
    ],
    products: [
        .executable(name: "herbie-helper", targets: ["HerbieHelper"])
    ],
    dependencies: [
        .package(
            url: "git@github.com:zaneenders/ScribeSystem.git",
            from: "0.0.2")
    ],
    targets: [
        .executableTarget(
            name: "HerbieHelper",
            dependencies: [
                .product(name: "ScribeSystem", package: "ScribeSystem")
            ], swiftSettings: swiftSettings)
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
