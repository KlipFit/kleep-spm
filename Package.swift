// swift-tools-version: 5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Klipfit",
    defaultLocalization: "fr",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "Klipfit",
            targets: ["Klipfit"]),
    ],
    targets: [
        .binaryTarget(name: "Klipfit", path: "Sources/Klipfit/Klipfit.xcframework"),
    ]
)
