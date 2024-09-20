// swift-tools-version:5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "HXPhotoPicker",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "HXPhotoPicker",
            targets: ["HXPhotoPicker"]),
    ],
    dependencies: [
        .package(url: "https://github.com/onevcat/Kingfisher", from: "8.1.3"),
    ],
    targets: [
        .target(
            name: "HXPhotoPicker",
            dependencies: ["Kingfisher"],
            resources: [
                .copy("Resources/HXPhotoPicker.bundle"),
                .copy("Resources/PrivacyInfo.xcprivacy")
            ],
            swiftSettings: [
                .define("HXPICKER_ENABLE_SPM"),
                .define("HXPICKER_ENABLE_PICKER"),
                .define("HXPICKER_ENABLE_EDITOR"),
                .define("HXPICKER_ENABLE_CAMERA")
            ]),
    ]
)
