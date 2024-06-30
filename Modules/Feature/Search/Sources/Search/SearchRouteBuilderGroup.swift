import Architecture
import LinkNavigator

// MARK: - SearchRouteBuilderGroup

public struct SearchRouteBuilderGroup<RootNavigator: RootNavigatorType> {
  public init() { }
}

extension SearchRouteBuilderGroup {
  public static var release: [RouteBuilderOf<RootNavigator>] {
    [
      RepoRouteBuilder.generate(),
      UserRouteBuilder.generate(),
    ]
  }
}
