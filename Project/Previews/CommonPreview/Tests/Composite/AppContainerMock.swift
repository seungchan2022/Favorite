import Architecture
import Common
import Domain
import Foundation
import LinkNavigator
import Platform

// MARK: - AppContainerMock

struct AppContainerMock: CommonEnvironmentUsable {

  // MARK: Lifecycle

  private init(
    toastViewActionMock: ToastViewActionMock,
    githubSearchUseCaseStub: GithubSearchUseCaseStub,
    githubDetailUseCaseStub: GithubDetailUseCaseStub,
    githubLikeUseCaseFake: GithubLikeUseCaseFake,
    githubUserUseCaseStub: GithubUserUsecCaseStub,
    linkNavigatorMock: TabLinkNavigatorMock)
  {
    self.toastViewActionMock = toastViewActionMock
    self.githubSearchUseCaseStub = githubSearchUseCaseStub
    self.githubDetailUseCaseStub = githubDetailUseCaseStub
    self.githubLikeUseCaseFake = githubLikeUseCaseFake
    self.githubUserUseCaseStub = githubUserUseCaseStub
    self.linkNavigatorMock = linkNavigatorMock
  }

  // MARK: Internal

  let toastViewActionMock: ToastViewActionMock
  let githubSearchUseCaseStub: GithubSearchUseCaseStub
  let githubDetailUseCaseStub: GithubDetailUseCaseStub
  let githubLikeUseCaseFake: GithubLikeUseCaseFake
  let githubUserUseCaseStub: GithubUserUsecCaseStub
  let linkNavigatorMock: TabLinkNavigatorMock

  var githubUserUseCase: GithubUserUseCase {
    githubUserUseCaseStub
  }

  var githubLikeUseCase: GithubLikeUseCaseFake {
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
      githubUserUseCaseStub: .init(),
      linkNavigatorMock: TabLinkNavigatorMock())
  }
}
