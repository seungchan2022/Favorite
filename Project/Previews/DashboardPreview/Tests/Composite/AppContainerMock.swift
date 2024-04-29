import Architecture
import Dashboard
import Domain
import Foundation
import Platform

// MARK: - AppContainerMock

final class AppContainerMock: DashboardEnvironmentUsable {

  // MARK: Lifecycle

  private init(
    toastViewModel: ToastViewModel,
    githubSearchUseCaseMock: GithubSearchUseCaseMock,
    githubDetailUseCase: GithubDetailUseCase,
    githubLikeUseCase: GithubLikeUseCase,
    githubUserUseCase: GithubUserUseCase,
    linkNavigatorMock: TabLinkNavigatorMock)
  {
    self.toastViewModel = toastViewModel
    self.githubSearchUseCaseMock = githubSearchUseCaseMock
    self.githubDetailUseCase = githubDetailUseCase
    self.githubLikeUseCase = githubLikeUseCase
    self.githubUserUseCase = githubUserUseCase
    self.linkNavigatorMock = linkNavigatorMock
  }

  // MARK: Internal

  let toastViewModel: ToastViewModel
  let githubSearchUseCaseMock: GithubSearchUseCaseMock
  let githubDetailUseCase: GithubDetailUseCase
  let githubLikeUseCase: GithubLikeUseCase
  let githubUserUseCase: GithubUserUseCase
  let linkNavigatorMock: TabLinkNavigatorMock

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
      toastViewModel: .init(),
      githubSearchUseCaseMock: .init(),
      githubDetailUseCase: GithubDetailUseCasePlatform(),
      githubLikeUseCase: GithubLikeUseCasePlatform(),
      githubUserUseCase: GithubUserUseCasePlatform(),
      linkNavigatorMock: TabLinkNavigatorMock())
  }
}
