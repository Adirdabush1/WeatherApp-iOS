// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "WeatherApp-iOS",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        // No products: this Package.swift is provided for dependency resolution
        // when using SwiftPM tooling or CI. The app is intended to be opened
        // in Xcode as a normal iOS application.
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.6.0"),
    ],
    targets: [
        .target(
            name: "AppTarget",
            dependencies: [
                .product(name: "Alamofire", package: "Alamofire")
            ],
            path: "Sources"
        )
    ]
)
