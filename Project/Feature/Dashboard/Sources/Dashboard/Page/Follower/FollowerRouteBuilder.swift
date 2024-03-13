import Architecture
import LinkNavigator

struct FollowerRouteBuilder<RootNavigator: RootNavigatorType> {
  static func generate() -> RouteBuilderOf<RootNavigator> {
    let matchPath = Link.Dashboard.Path.follower.rawValue
    
    return .init(matchPath: matchPath) { navigator, items, diContainer -> RouteViewController? in
      guard let env: DashboardEnvironmentUsable = diContainer.resolve() else { return .none }
      
      return DebugWrappingController(matchPath: matchPath) {
        FollowerPage(store: .init(
          initialState: FollowerReducer.State(),
          reducer: {
            FollowerReducer(sideEffect: .init(
              useCase: env,
              navigator: navigator))
          }))
      }
    }
  }
}
