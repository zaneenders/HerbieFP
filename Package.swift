// swift-tools-version: 5.8

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
        .package(name: "ScribeSystem", path: "../ScribeSystem/")
    ],
    targets: [
        .executableTarget(
            name: "HerbieHelper",
            dependencies: [
                .product(name: "ScribeSystem", package: "ScribeSystem")
            ])
    ]
)
