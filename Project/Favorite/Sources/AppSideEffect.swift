import Architecture
import Common
import Domain
import Foundation
import Like
import LinkNavigator
import Platform
import Search
import Authentication
import Me

// MARK: - AppSideEffect

struct AppSideEffect: DependencyType, SearchEnvironmentUsable, CommonEnvironmentUsable, LikeEnvironmentUsable, AuthenticationEnvironmentUsable, MeEnvironmentUsable {
  let toastViewModel: ToastViewActionType
  let githubSearchUseCase: GithubSearchUseCase
  let githubDetailUseCase: GithubDetailUseCase
  let githubLikeUseCase: GithubLikeUseCase
  let githubUserUseCase: GithubUserUseCase
}
