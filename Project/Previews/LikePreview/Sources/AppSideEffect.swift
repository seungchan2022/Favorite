import Architecture
import Domain
import Foundation
import Like
import LinkNavigator
import Platform

// MARK: - AppSideEffect

struct AppSideEffect: DependencyType, LikeEnvironmentUsable {
  let toastViewModel: ToastViewActionType
  let githubLikeUseCase: GithubLikeUseCase
}
