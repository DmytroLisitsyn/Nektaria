// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Nektaria",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(name: "Nektaria", targets: ["Nektaria"]),
    ],
    targets: [
        .target(name: "Nektaria", dependencies: []),
        .testTarget(name: "NektariaTests", dependencies: ["Nektaria"]),
    ]
)
