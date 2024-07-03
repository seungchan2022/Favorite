// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Platform",
  platforms: [
    .iOS(.v17),
  ],
  products: [
    .library(
      name: "Platform",
      targets: ["Platform"]),
  ],
  dependencies: [
    .package(path: "../../Core/Domain"),
    .package(
      url: "https://github.com/CombineCommunity/CombineExt.git",
      .upToNextMajor(from: "1.8.1")),
    .package(
      url: "https://github.com/apple/swift-log.git",
      .upToNextMajor(from: "1.5.3")),
    .package(
      url: "https://github.com/firebase/firebase-ios-sdk.git",
      .upToNextMajor(from: "10.28.1")),
  ],
  targets: [
    .target(
      name: "Platform",
      dependencies: [
        "Domain",
        "CombineExt",
        .product(name: "Logging", package: "swift-log"),
        .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
      ],
      resources: [
        .copy("Resources/Mock/dummy.json"),
        .copy("Resources/Mock/search_repositories_success.json"),
        .copy("Resources/Mock/search_repositories_failure.json"),
        .copy("Resources/Mock/search_users_success.json"),
        .copy("Resources/Mock/search_users_failure.json"),
        .copy("Resources/Mock/detail_repositories_success.json"),
        .copy("Resources/Mock/detail_repositories_failure.json"),
        .copy("Resources/Mock/detail_users_success.json"),
        .copy("Resources/Mock/detail_users_failure.json"),
        .copy("Resources/Mock/user_followers_success.json"),
        .copy("Resources/Mock/user_followers_failure.json"),
      ]),
    .testTarget(
      name: "PlatformTests",
      dependencies: ["Platform"]),
  ])
