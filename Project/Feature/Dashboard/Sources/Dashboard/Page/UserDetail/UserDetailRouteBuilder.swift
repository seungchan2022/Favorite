import Architecture
import LinkNavigator
import Domain

struct UserDetailRouteBuilder<RootNavigator: RootNavigatorType> {
  static func generate() -> RouteBuilderOf<RootNavigator> {
    let matchPath = Link.Dashboard.Path.userDetail.rawValue

    return .init(matchPath: matchPath) { navigator, items, diConatiner -> RouteViewController? in

      guard let env: DashboardEnvironmentUsable = diConatiner.resolve() else { return .none }
      guard let query: GithubEntity.Detail.User.Request = items.decoded() else { return .none }

      return DebugWrappingController(matchPath: matchPath) {
        UserDetailPage(store: .init(
          initialState: UserDetailStore.State(item: query),
          reducer: {
            UserDetailStore(sideEffect: .init(
              useCase: env,
              navigator: navigator))
          }))
      }
    }
  }
}
