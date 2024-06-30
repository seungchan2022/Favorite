// swift-tools-version: 5.10

import PackageDescription

let package = Package(
  name: "Common",
  platforms: [.iOS(.v17)],
  products: [
    .library(
      name: "Common",
      targets: ["Common"]),
  ],
  dependencies: [
    .package(path: "../../../Core/Architecture"),

  ],
  targets: [
    .target(
      name: "Common",
      dependencies: [
        "Architecture",

      ]),
    .testTarget(
      name: "CommonTests",
      dependencies: ["Common"]),
  ])
