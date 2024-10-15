// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "mp-sideloaded-kit-example",
    platforms: [ .iOS(.v11) ],
    products: [
        .library(
            name: "mp-sideloaded-kit-example",
            targets: ["mp-sideloaded-kit-example"])
    ],
    dependencies: [
      .package(name: "mParticle-Apple-SDK",
               url: "https://github.com/mParticle/mparticle-apple-sdk",
               .upToNextMajor(from: "8.0.0"))
    ],
    targets: [
        .target(
            name: "mp-sideloaded-kit-example",
            dependencies: [
              .byName(name: "mParticle-Apple-SDK")
            ],
            path: "src")
    ]
)
