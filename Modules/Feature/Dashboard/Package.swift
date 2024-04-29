// swift-tools-version: 5.10

import PackageDescription

let package = Package(
  name: "Dashboard",
  platforms: [.iOS(.v17)],
  products: [
    .library(
      name: "Dashboard",
      targets: ["Dashboard"]),
  ],
  dependencies: [
    .package(path: "../../../Core/Architecture"),
//     .package(path: "../../../Core/Domain"),
//     .package(path: "../../../Core/Platform"),
//     .package(path: "../../../Core/Functor"),
  ],
  targets: [
    .target(
      name: "Dashboard",
      dependencies: [
        "Architecture",
//         "Domain",
//         "Platform",
//         "Functor",
      ]),
    .testTarget(
      name: "DashboardTests",
      dependencies: ["Dashboard"]),
  ])
