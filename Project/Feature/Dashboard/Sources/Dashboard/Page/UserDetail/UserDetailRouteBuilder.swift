import Architecture
import LinkNavigator

struct UserDetailRouteBuilder<RootNavigator: RootNavigatorType> {
  static func generate() -> RouteBuilderOf<RootNavigator> {
    let matchPath = Link.Dashboard.Path.userDetail.rawValue

    return .init(matchPath: matchPath) { navigator, _, diConatiner -> RouteViewController? in

      guard let env: DashboardEnvironmentUsable = diConatiner.resolve() else { return .none }

      return DebugWrappingController(matchPath: matchPath) {
        UserDetailPage(store: .init(
          initialState: UserDetailStore.State(),
          reducer: {
            UserDetailStore(sideEffect: .init(
              useCase: env,
              navigator: navigator))
          }))
      }
    }
  }
}
