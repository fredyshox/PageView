// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PageView",
    platforms: [
        .iOS(.v14),
        .watchOS(.v7)
    ],
    products: [
        .library(name: "PageView", targets: ["PageView"]),
    ],
    targets: [
        .target(name: "PageView", path: "Sources/"),
        .testTarget(name: "PageViewTests", dependencies: ["PageView"]),
    ],
    swiftLanguageVersions: [.v5]
)
