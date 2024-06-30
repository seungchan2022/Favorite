import ProjectDescription
import ProjectDescriptionHelpers

let targetList: [Target] = [
  .target(
    name: "Favorite-Production",
    destinations: .iOS,
    product: .app,
    productName: "Favorite",
    bundleId: "io.seungchan.favorite",
    deploymentTargets: .default,
    infoPlist: .defaultInfoPlist,
    sources: ["Sources/**"],
    resources: ["Resources/**"],
    copyFiles: .none,
    headers: .none,
    entitlements: .none,
    scripts: [],
    dependencies: .default,
    settings: .defaultConfig(false),
    coreDataModels: [],
    environmentVariables: [:],
    launchArguments: [],
    additionalFiles: [],
    buildRules: [],
    mergedBinaryType: .disabled,
    mergeable: false),

  .target(
    name: "Favorite-QA",
    destinations: .iOS,
    product: .app,
    productName: "Favorite",
    bundleId: "io.seungchan.favorite",
    deploymentTargets: .iOS("17.0"),
    infoPlist: .defaultInfoPlist,
    sources: ["Sources/**"],
    resources: ["Resources/**"],
    copyFiles: .none,
    headers: .none,
    entitlements: .none,
    scripts: [],
    dependencies: .default,
    settings: .defaultConfig(true),
    coreDataModels: [],
    environmentVariables: [:],
    launchArguments: [],
    additionalFiles: [],
    buildRules: [],
    mergedBinaryType: .disabled,
    mergeable: false),
]

let project: Project = .init(
  name: "FavoriteApplication",
  organizationName: "SeungChanMoon",
  options: .options(),
  packages: [],
  settings: .settings(),
  targets: targetList,
  schemes: [],
  fileHeaderTemplate: .none,
  additionalFiles: [],
  resourceSynthesizers: [])

extension [TargetDependency] {
  public static var `default`: Self {
    [
      .package(product: "Search", type: .runtime),
      .package(product: "Like", type: .runtime),
      .package(product: "Common", type: .runtime),
    ]
  }
}
