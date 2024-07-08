import Architecture
import LinkNavigator

// MARK: - MeRouteBuilderGroup

public struct MeRouteBuilderGroup<RootNavigator: RootNavigatorType> {
  public init() { }
}

extension MeRouteBuilderGroup {
  public static var release: [RouteBuilderOf<RootNavigator>] {
    [
      MeRouteBuilder.generate(),
    ]
  }

  public static var template: [RouteBuilderOf<RootNavigator>] {
    [
      SignInRouteBuilder.generate(),
      SignUpRouteBuilder.generate(),
      UpdateAuthRouteBuilder.generate(),
      UpdatePasswordRouteBuilder.generate(),
      UpdateProfileImageRouteBuilder.generate(),
    ]
  }
}
