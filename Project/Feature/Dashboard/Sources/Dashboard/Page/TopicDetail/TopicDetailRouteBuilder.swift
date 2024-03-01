import Architecture
import LinkNavigator

struct TopicDetailRouteBuilder<RootNavigator: RootNavigatorType> {
  static func generate() -> RouteBuilderOf<RootNavigator> {
    let matchPath = Link.Dashboard.Path.topicDetail.rawValue

    return .init(matchPath: matchPath) { navigator, _, diContainer -> RouteViewController? in
      guard let env: DashboardEnvironmentUsable = diContainer.resolve() else { return .none }

      return DebugWrappingController(matchPath: matchPath) {
        TopicDetailPage(store: .init(
          initialState: TopicDetailStore.State(),
          reducer: {
            TopicDetailStore(sideEffect: .init(
              useCase: env,
              navigator: navigator))
          }))
      }
    }
  }
}
