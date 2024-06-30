// swift-tools-version: 5.10

import PackageDescription

let package = Package(
  name: "Search",
  platforms: [.iOS(.v17)],
  products: [
    .library(
      name: "Search",
      targets: ["Search"]),
  ],
  dependencies: [
    .package(path: "../../../Core/Architecture"),

  ],
  targets: [
    .target(
      name: "Search",
      dependencies: [
        "Architecture",

      ]),
    .testTarget(
      name: "SearchTests",
      dependencies: ["Search"]),
  ])
