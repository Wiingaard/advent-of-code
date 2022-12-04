// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CampCleanup",
    platforms: [.macOS(.v12)],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-parsing", from: "0.7.0"),
    ],
    targets: [
        .executableTarget(
            name: "CampCleanup",
            dependencies: [
                .product(name: "Parsing", package: "swift-parsing")
            ]
        )
    ]
)
