import Architecture
import Domain
import Foundation
import LinkNavigator
import Me
import Platform

// MARK: - AppSideEffect

struct AppSideEffect: DependencyType, MeEnvironmentUsable {
  let toastViewModel: ToastViewActionType
}
