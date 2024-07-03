import Architecture
import Authentication
import Domain
import Foundation
import LinkNavigator
import Platform

// MARK: - AppContainerMock

struct AppContainerMock: AuthenticationEnvironmentUsable {

  // MARK: Lifecycle

  private init(
    toastViewActionMock: ToastViewActionMock,
    githubSearchUseCaseStub: GithubSearchUseCaseStub,
    githubDetailUseCaseStub: GithubDetailUseCaseStub,
    githubAuthenticationUseCaseFake: GithubAuthenticationUseCaseFake,
    githubUserUseCaseStub: GithubUserUsecCaseStub,
    linkNavigatorMock: TabLinkNavigatorMock)
  {
    self.toastViewActionMock = toastViewActionMock
    self.githubSearchUseCaseStub = githubSearchUseCaseStub
    self.githubDetailUseCaseStub = githubDetailUseCaseStub
    self.githubAuthenticationUseCaseFake = githubAuthenticationUseCaseFake
    self.githubUserUseCaseStub = githubUserUseCaseStub
    self.linkNavigatorMock = linkNavigatorMock
  }

  // MARK: Internal

  let toastViewActionMock: ToastViewActionMock
  let githubSearchUseCaseStub: GithubSearchUseCaseStub
  let githubDetailUseCaseStub: GithubDetailUseCaseStub
  let githubAuthenticationUseCaseFake: GithubAuthenticationUseCaseFake
  let githubUserUseCaseStub: GithubUserUsecCaseStub
  let linkNavigatorMock: TabLinkNavigatorMock

  var githubUserUseCase: GithubUserUseCase {
    githubUserUseCaseStub
  }

  var githubAuthenticationUseCase: GithubAuthenticationUseCase {
    githubAuthenticationUseCaseFake
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
      githubAuthenticationUseCaseFake: .init(),
      githubUserUseCaseStub: .init(),
      linkNavigatorMock: TabLinkNavigatorMock())
  }
}
