import Architecture
import Dashboard
import Domain
import Foundation
import LinkNavigator
import Platform

// MARK: - AppContainerMock

struct AppContainerMock: DashboardEnvironmentUsable {

  // MARK: Lifecycle

  private init(
    toastViewActionMock: ToastViewActionMock,
    githubSearchUseCaseStub: GithubSearchUseCaseStub,
    githubDetailUseCaseStub: GithubDetailUseCaseStub,
    githubLikeUseCaseFake: GIthubLikeUseCaseFake,
    githubUserUseCase: GithubUserUseCase,
    linkNavigatorMock: TabLinkNavigatorMock)
  {
    self.toastViewActionMock = toastViewActionMock
    self.githubSearchUseCaseStub = githubSearchUseCaseStub
    self.githubDetailUseCaseStub = githubDetailUseCaseStub
    self.githubLikeUseCaseFake = githubLikeUseCaseFake
    self.githubUserUseCase = githubUserUseCase
    self.linkNavigatorMock = linkNavigatorMock
  }

  // MARK: Internal

  let toastViewActionMock: ToastViewActionMock
  let githubSearchUseCaseStub: GithubSearchUseCaseStub
  let githubDetailUseCaseStub: GithubDetailUseCaseStub
  let githubLikeUseCaseFake: GIthubLikeUseCaseFake
  let githubUserUseCase: GithubUserUseCase
  let linkNavigatorMock: TabLinkNavigatorMock

  var githubLikeUseCase: GithubLikeUseCase {
    githubLikeUseCaseFake
  }

  var githubDetailUseCase: GithubDetailUseCase {
    githubDetailUseCaseStub
  }

  var toastViewModel: ToastViewActionType {
    toastViewActionMock
  }

  var githubSearchUseCase: GithubSearchUseCase {
    githubSearchUseCaseStub
  }

  var linkNavigator: RootNavigatorType {
    linkNavigatorMock
  }

}

extension AppContainerMock {
  static func generate() -> AppContainerMock {
    .init(
      toastViewActionMock: .init(),
      githubSearchUseCaseStub: .init(),
      githubDetailUseCaseStub: .init(),
      githubLikeUseCaseFake: .init(),
      githubUserUseCase: GithubUserUseCasePlatform(),
      linkNavigatorMock: TabLinkNavigatorMock())
  }
}
