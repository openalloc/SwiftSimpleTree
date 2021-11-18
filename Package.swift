// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "SwiftSimpleTree",
    products: [
        .library(name: "SimpleTree", targets: ["SimpleTree"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SimpleTree",
            dependencies: [],
            path: "Sources"
        ),
        .testTarget(
            name: "SimpleTreeTests",
            dependencies: ["SimpleTree"],
            path: "Tests"
        ),
    ]
)
