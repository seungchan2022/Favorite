import Architecture
import LinkNavigator

struct ProfileRouteBuilder<RootNavigator: RootNavigatorType> {
  static func generate() -> RouteBuilderOf<RootNavigator> {
    let matchPath = Link.Dashboard.Path.profile.rawValue

    return .init(matchPath: matchPath) { navigator, _, diConatiner -> RouteViewController? in

      guard let env: DashboardEnvironmentUsable = diConatiner.resolve() else { return .none }

      return DebugWrappingController(matchPath: matchPath) {
        ProfilePage(store: .init(
          initialState: ProfileStore.State(),
          reducer: {
            ProfileStore(sideEffect: .init(
              useCase: env,
              navigator: navigator))
          }))
      }
    }
  }
}
