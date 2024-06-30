import Architecture
import Domain
import Foundation
import LinkNavigator
import Platform
import Search

// MARK: - AppSideEffect

struct AppSideEffect: DependencyType, SearchEnvironmentUsable {
  let toastViewModel: ToastViewActionType
  let githubSearchUseCase: GithubSearchUseCase
}
