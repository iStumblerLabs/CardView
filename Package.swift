// swift-tools-version:5.10

import PackageDescription

let package = Package(
    name: "CardView",
    platforms: [.macOS(.v10_14), .iOS(.v14), .tvOS(.v14)],
    products: [
        .library( name: "CardView", type: .dynamic, targets: ["CardView"])
    ],
    dependencies: [
      .package( url: "https://github.com/iStumblerLabs/KitBridge.git", from: "1.3.2")
    ],
    targets: [
        .target(
            name: "CardView",
            dependencies: ["KitBridge"]
        )
    ]
)
