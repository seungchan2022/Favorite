import Architecture
import Dashboard
import Domain
import Foundation
import LinkNavigator
import Platform

// MARK: - AppContainerMock

final class AppContainerMock: DashboardEnvironmentUsable {

  // MARK: Lifecycle

  private init(
    toastViewActionMock: ToastViewActionMock,
    githubSearchUseCaseMock: GithubSearchUseCaseMock,
    githubDetailUseCase: GithubDetailUseCase,
    githubLikeUseCase: GithubLikeUseCase,
    githubUserUseCase: GithubUserUseCase,
    linkNavigatorMock: TabLinkNavigatorMock)
  {
    self.toastViewActionMock = toastViewActionMock
    self.githubSearchUseCaseMock = githubSearchUseCaseMock
    self.githubDetailUseCase = githubDetailUseCase
    self.githubLikeUseCase = githubLikeUseCase
    self.githubUserUseCase = githubUserUseCase
    self.linkNavigatorMock = linkNavigatorMock
  }

  // MARK: Internal

  let toastViewActionMock: ToastViewActionMock
  let githubSearchUseCaseMock: GithubSearchUseCaseMock
  let githubDetailUseCase: GithubDetailUseCase
  let githubLikeUseCase: GithubLikeUseCase
  let githubUserUseCase: GithubUserUseCase
  let linkNavigatorMock: TabLinkNavigatorMock

  var toastViewModel: ToastViewActionType {
    toastViewActionMock
  }

  var githubSearchUseCase: GithubSearchUseCase {
    githubSearchUseCaseMock
  }

  var linkNavigator: RootNavigatorType {
    linkNavigatorMock
  }

}

extension AppContainerMock {
  class func generate() -> AppContainerMock {
    .init(
      toastViewActionMock: .init(),
      githubSearchUseCaseMock: .init(),
      githubDetailUseCase: GithubDetailUseCasePlatform(),
      githubLikeUseCase: GithubLikeUseCasePlatform(),
      githubUserUseCase: GithubUserUseCasePlatform(),
      linkNavigatorMock: TabLinkNavigatorMock())
  }
}
