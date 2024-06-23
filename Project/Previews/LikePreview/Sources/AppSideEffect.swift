import Architecture
import Domain
import Foundation
import LinkNavigator
import Platform
import Like

// MARK: - AppSideEffect

struct AppSideEffect: DependencyType, LikeEnvironmentUsable {
  let toastViewModel: ToastViewActionType
  let githubSearchUseCase: GithubSearchUseCase
  let githubDetailUseCase: GithubDetailUseCase
  let githubLikeUseCase: GithubLikeUseCase
  let githubUserUseCase: GithubUserUseCase
}
