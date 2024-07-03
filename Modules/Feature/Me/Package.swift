// swift-tools-version: 5.10

import PackageDescription

let package = Package(
  name: "Me",
  platforms: [.iOS(.v17)],
  products: [
    .library(
      name: "Me",
      targets: ["Me"]),
  ],
  dependencies: [
    .package(path: "../../../Core/Architecture"),

  ],
  targets: [
    .target(
      name: "Me",
      dependencies: [
        "Architecture",

      ]),
    .testTarget(
      name: "MeTests",
      dependencies: ["Me"]),
  ])
