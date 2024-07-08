import Architecture
import LinkNavigator

// MARK: - AuthenticationRouteBuilderGroup

public struct AuthenticationRouteBuilderGroup<RootNavigator: RootNavigatorType> {
  public init() { }
}

extension AuthenticationRouteBuilderGroup {
  public static var release: [RouteBuilderOf<RootNavigator>] {
    [
      SignInRouteBuilder.generate(),
      SignUpRouteBuilder.generate(),
      UpdateAuthRouteBuilder.generate(),
      UpdatePasswordRouteBuilder.generate(),
      UpdateProfileImageRouteBuilder.generate(),
    ]
  }

  public static var template: [RouteBuilderOf<RootNavigator>] {
    [
      MeRouteBuilder.generate(),
    ]
  }
}
