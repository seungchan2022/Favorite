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
    githubDetailUseCaseMock: GithubDetailUseCaseMock,
    githubLikeUseCaseMock: GithubLikeUseCaseMock,
    githubUserUseCase: GithubUserUseCase,
    linkNavigatorMock: TabLinkNavigatorMock)
  {
    self.toastViewActionMock = toastViewActionMock
    self.githubSearchUseCaseMock = githubSearchUseCaseMock
    self.githubDetailUseCaseMock = githubDetailUseCaseMock
    self.githubLikeUseCaseMock = githubLikeUseCaseMock
    self.githubUserUseCase = githubUserUseCase
    self.linkNavigatorMock = linkNavigatorMock
  }

  // MARK: Internal

  let toastViewActionMock: ToastViewActionMock
  let githubSearchUseCaseMock: GithubSearchUseCaseMock
  let githubDetailUseCaseMock: GithubDetailUseCaseMock
  let githubLikeUseCaseMock: GithubLikeUseCaseMock
  let githubUserUseCase: GithubUserUseCase
  let linkNavigatorMock: TabLinkNavigatorMock

  var githubLikeUseCase: GithubLikeUseCase {
    githubLikeUseCaseMock
  }

  var githubDetailUseCase: GithubDetailUseCase {
    githubDetailUseCaseMock
  }

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
      githubDetailUseCaseMock: .init(),
      githubLikeUseCaseMock: GithubLikeUseCaseMock(),
      githubUserUseCase: GithubUserUseCasePlatform(),
      linkNavigatorMock: TabLinkNavigatorMock())
  }
}
