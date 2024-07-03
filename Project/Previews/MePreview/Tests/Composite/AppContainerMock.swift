import Architecture
import Domain
import Foundation
import LinkNavigator
import Me
import Platform

// MARK: - AppContainerMock

struct AppContainerMock: MeEnvironmentUsable {

  // MARK: Lifecycle

  private init(
    toastViewActionMock: ToastViewActionMock,
    githubSearchUseCaseStub: GithubSearchUseCaseStub,
    githubDetailUseCaseStub: GithubDetailUseCaseStub,
    githubMeUseCaseFake: GithubMeUseCaseFake,
    githubUserUseCaseStub: GithubUserUsecCaseStub,
    linkNavigatorMock: TabLinkNavigatorMock)
  {
    self.toastViewActionMock = toastViewActionMock
    self.githubSearchUseCaseStub = githubSearchUseCaseStub
    self.githubDetailUseCaseStub = githubDetailUseCaseStub
    self.githubMeUseCaseFake = githubMeUseCaseFake
    self.githubUserUseCaseStub = githubUserUseCaseStub
    self.linkNavigatorMock = linkNavigatorMock
  }

  // MARK: Internal

  let toastViewActionMock: ToastViewActionMock
  let githubSearchUseCaseStub: GithubSearchUseCaseStub
  let githubDetailUseCaseStub: GithubDetailUseCaseStub
  let githubMeUseCaseFake: GithubMeUseCaseFake
  let githubUserUseCaseStub: GithubUserUsecCaseStub
  let linkNavigatorMock: TabLinkNavigatorMock

  var githubUserUseCase: GithubUserUseCase {
    githubUserUseCaseStub
  }

  var githubMeUseCase: GithubMeUseCase {
    githubMeUseCaseFake
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
      githubMeUseCaseFake: .init(),
      githubUserUseCaseStub: .init(),
      linkNavigatorMock: TabLinkNavigatorMock())
  }
}
