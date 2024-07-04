import Architecture
import Authentication
import Common
import Domain
import Foundation
import Like
import LinkNavigator
import Me
import Platform
import Search

// MARK: - AppSideEffect

struct AppSideEffect: DependencyType, SearchEnvironmentUsable, CommonEnvironmentUsable, LikeEnvironmentUsable,
  AuthenticationEnvironmentUsable, MeEnvironmentUsable
{
  
  let toastViewModel: ToastViewActionType
  let githubSearchUseCase: GithubSearchUseCase
  let githubDetailUseCase: GithubDetailUseCase
  let githubLikeUseCase: GithubLikeUseCase
  let githubUserUseCase: GithubUserUseCase
  let authUseCase: AuthUseCase
}
