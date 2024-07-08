import Architecture
import LinkNavigator

struct UpdateProfileImageRouteBuilder<RootNavigator: RootNavigatorType> {
  static func generate() -> RouteBuilderOf<RootNavigator> {
    let matchPath = Link.Authentication.Path.updateProfileImage.rawValue

    return .init(matchPath: matchPath) { navigator, _, diContainer -> RouteViewController? in
      guard let env: AuthenticationEnvironmentUsable = diContainer.resolve() else { return .none }

      return DebugWrappingController(matchPath: matchPath) {
        UpdateProfileImagePage(
          store: .init(
            initialState: UpdateProfileImageReducer.State(),
            reducer: {
              UpdateProfileImageReducer(
                sideEffect: .init(
                  useCase: env,
                  navigator: navigator))
            }))
      }
    }
  }
}
