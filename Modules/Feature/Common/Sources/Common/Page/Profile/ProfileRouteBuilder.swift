import Architecture
import Domain
import LinkNavigator

struct ProfileRouteBuilder<RootNavigator: RootNavigatorType> {
  static func generate() -> RouteBuilderOf<RootNavigator> {
    let matchPath = Link.Common.Path.profile.rawValue

    return .init(matchPath: matchPath) { navigator, items, diContainer -> RouteViewController? in

      guard let env: CommonEnvironmentUsable = diContainer.resolve() else { return .none }
      guard let item: GithubEntity.Detail.User.Request = items.decoded() else { return .none }

      return DebugWrappingController(matchPath: matchPath) {
        ProfilePage(store: .init(
          initialState: ProfileReducer.State(item: item),
          reducer: {
            ProfileReducer(sideEffect: .init(
              useCase: env,
              navigator: navigator))
          }))
      }
    }
  }
}
