import Architecture
import LinkNavigator

// MARK: - CommonRouteBuilderGroup

public struct CommonRouteBuilderGroup<RootNavigator: RootNavigatorType> {
  public init() { }
}

extension CommonRouteBuilderGroup {
  public static var release: [RouteBuilderOf<RootNavigator>] {
    [
      RepoDetailRouteBuilder.generate(),
      UserDetailRouteBuilder.generate(),
      ProfileRouteBuilder.generate(),
      FollowerRouteBuilder.generate(),
    ]
  }

  public static var template: [RouteBuilderOf<RootNavigator>] {
    [
    ]
  }
}
