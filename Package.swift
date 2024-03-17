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
        .executable(name: "herbie-helper", targets: ["HerbieHelper"])
    ],
    dependencies: [
        .package(
            url: "git@github.com:zaneenders/ScribeSystem.git",
            revision: "6a23a7b"),
        .package(
            url: "git@github.com:zaneenders/FPCore.git", revision: "b1c89f0"),
        // .package(name: "ScribeSystem", path: "../ScribeSystem/"),
    ],
    targets: [
        .executableTarget(
            name: "HerbieHelper",
            dependencies: [
                .product(name: "ScribeSystem", package: "ScribeSystem"),
                .product(name: "FPCore", package: "FPCore"),
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
