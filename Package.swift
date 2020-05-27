// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "SwiftWeb",
    platforms: [
        .macOS(.v10_15),
    ],
    products: [
        .library(name: "SwiftWeb", targets: ["SwiftWeb"]),
        .library(name: "SwiftWebScript", targets: ["SwiftWebScript"]),
    ],
    targets: [
        .target(name: "SwiftWeb"),
        .target(name: "SwiftWebScript"),
        .testTarget(name: "SwiftWebTests", dependencies: ["SwiftWeb"]),
    ]
)
