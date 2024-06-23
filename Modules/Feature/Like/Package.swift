// swift-tools-version: 5.10

import PackageDescription

let package = Package(
  name: "Like",
  platforms: [.iOS(.v17)],
  products: [
    .library(
      name: "Like",
      targets: ["Like"]),
  ],
  dependencies: [
    .package(path: "../../../Core/Architecture"),

  ],
  targets: [
    .target(
      name: "Like",
      dependencies: [
        "Architecture",

      ]),
    .testTarget(
      name: "LikeTests",
      dependencies: ["Like"]),
  ])
