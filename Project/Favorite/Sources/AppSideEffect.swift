import Architecture
import Common
import Domain
import Foundation
import Like
import LinkNavigator
import Platform
import Search

// MARK: - AppSideEffect

struct AppSideEffect: DependencyType, SearchEnvironmentUsable, CommonEnvironmentUsable, LikeEnvironmentUsable {
  let toastViewModel: ToastViewActionType
  let githubSearchUseCase: GithubSearchUseCase
  let githubDetailUseCase: GithubDetailUseCase
  let githubLikeUseCase: GithubLikeUseCase
  let githubUserUseCase: GithubUserUseCase
}
