// swift-tools-version:5.9
// Shared domain logic for the iOS app, tested on the macOS host with XCTest.
import PackageDescription

let package = Package(
    name: "MobileCore",
    platforms: [.macOS(.v13), .iOS(.v16)],
    products: [
        .library(name: "MobileCore", targets: ["MobileCore"]),
    ],
    targets: [
        .target(name: "MobileCore"),
        .testTarget(name: "MobileCoreTests", dependencies: ["MobileCore"]),
    ]
)
