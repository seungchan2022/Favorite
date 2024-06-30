import ProjectDescription
import ProjectDescriptionHelpers

let project: Project = .preview(
  projectName: "Search",
  packages: [
    .local(path: .relativeToRoot("Modules/Core/Architecture")),
    .local(path: .relativeToRoot("Modules/Core/DesignSystem")),
    .local(path: .relativeToRoot("Modules/Core/Domain")),
    .local(path: .relativeToRoot("Modules/Core/Platform")),
    .local(path: .relativeToRoot("Modules/Core/Functor")),
    .local(path: .relativeToRoot("Modules/Feature/Search")),
  ],
  dependencies: [
    .package(product: "Search", type: .runtime),
  ])
