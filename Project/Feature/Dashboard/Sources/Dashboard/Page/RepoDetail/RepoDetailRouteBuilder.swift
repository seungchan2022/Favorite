import Architecture
import LinkNavigator
import Domain

struct RepoDetailRouteBuilder<RootNavigator: RootNavigatorType> {
  static func generate() -> RouteBuilderOf<RootNavigator> {
    let matchPath = Link.Dashboard.Path.repoDetail.rawValue

    return .init(matchPath: matchPath) { navigator, items, diContainer -> RouteViewController? in
      guard let env: DashboardEnvironmentUsable = diContainer.resolve() else { return .none }
      guard let query: GithubEntity.Detail.Repository.Request = items.decoded() else { return .none }

      return DebugWrappingController(matchPath: matchPath) {
        RepoDetailPage(store: .init(
          initialState: RepoDetailStore.State(item: query),
          reducer: {
            RepoDetailStore(sideEffect: .init(
              useCase: env,
              navigator: navigator))
          }))
      }
    }
  }
}