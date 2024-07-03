import Architecture
import Domain
import Foundation
import Me
import LinkNavigator
import Platform

// MARK: - AppSideEffect

struct AppSideEffect: DependencyType, MeEnvironmentUsable {
  let toastViewModel: ToastViewActionType
}
