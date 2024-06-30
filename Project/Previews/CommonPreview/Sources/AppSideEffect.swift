import Architecture
import Common
import Domain
import Foundation
import LinkNavigator
import Platform

// MARK: - AppSideEffect

struct AppSideEffect: DependencyType, CommonEnvironmentUsable {
  let toastViewModel: ToastViewActionType
  let githubDetailUseCase: GithubDetailUseCase
  let githubLikeUseCase: GithubLikeUseCase
  let githubUserUseCase: GithubUserUseCase
}
