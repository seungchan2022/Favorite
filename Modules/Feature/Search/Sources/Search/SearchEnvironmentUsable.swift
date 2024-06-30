import Architecture
import Domain

public protocol SearchEnvironmentUsable {
  var toastViewModel: ToastViewActionType { get }
  var githubSearchUseCase: GithubSearchUseCase { get }
}
