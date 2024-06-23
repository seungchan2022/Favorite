import Architecture
import Domain
import LinkNavigator

struct FollowerRouteBuilder<RootNavigator: RootNavigatorType> {
  static func generate() -> RouteBuilderOf<RootNavigator> {
    let matchPath = Link.Dashboard.Path.follower.rawValue

    return .init(matchPath: matchPath) { navigator, items, diContainer -> RouteViewController? in
      guard let env: LikeEnvironmentUsable = diContainer.resolve() else { return .none }
      guard let item: GithubEntity.User.Follower.Request = items.decoded() else { return .none }

      return DebugWrappingController(matchPath: matchPath) {
        FollowerPage(store: .init(
          initialState: FollowerReducer.State(item: item),
          reducer: {
            FollowerReducer(sideEffect: .init(
              useCase: env,
              navigator: navigator))
          }))
      }
    }
  }
}
