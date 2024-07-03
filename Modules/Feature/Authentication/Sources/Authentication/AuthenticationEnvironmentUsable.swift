import Architecture
import Domain

public protocol AuthenticationEnvironmentUsable {
  var toastViewModel: ToastViewActionType { get }
  var authUseCase: AuthUseCase { get }
}
