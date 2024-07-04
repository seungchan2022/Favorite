import Architecture
import Domain

public protocol MeEnvironmentUsable {
  var toastViewModel: ToastViewActionType { get }
  var authUseCase: AuthUseCase { get }
}
