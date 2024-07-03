import Architecture
import LinkNavigator

// MARK: - AuthenticationRouteBuilderGroup

public struct AuthenticationRouteBuilderGroup<RootNavigator: RootNavigatorType> {
  public init() { }
}

extension AuthenticationRouteBuilderGroup {
  public static var release: [RouteBuilderOf<RootNavigator>] {
    [
      HomeRouteBuilder.generate(),
      SignInRouteBuilder.generate(),
      SignUpRouteBuilder.generate(),
    ]
  }

  public static var template: [RouteBuilderOf<RootNavigator>] {
    [
    ]
  }
}
