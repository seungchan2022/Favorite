import Architecture
import Foundation
import LinkNavigator
import Platform

// MARK: - AppContainer

final class AppContainer {

  // MARK: Lifecycle

  private init(dependency: AppSideEffect, navigator: SingleLinkNavigator) {
    self.dependency = dependency
    self.navigator = navigator
  }

  // MARK: Internal

  let dependency: AppSideEffect
  let navigator: SingleLinkNavigator
}

extension AppContainer {
  class func build() -> AppContainer {
    let sideEffect = AppSideEffect(
      toastViewModel: ToastViewModel(),
      githubSearchUseCase: GithubSearchUseCasePlatform(),
      githubDetailUseCase: GithubDetailUseCasePlatform(),
      githubLikeUseCase: GithubLikeUseCasePlatform(),
      githubUserUseCase: GithubUserUseCasePlatform(),
      authUseCase: AuthUseCasePlatform())

    return .init(
      dependency: sideEffect,
      navigator: .init(
        routeBuilderItemList: AppRouteBuilderGroup().release,
        dependency: sideEffect))
  }
}
