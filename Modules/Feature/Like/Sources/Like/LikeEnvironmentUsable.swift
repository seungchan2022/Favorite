import Architecture
import Domain

public protocol LikeEnvironmentUsable {
  var toastViewModel: ToastViewActionType { get }
  var githubLikeUseCase: GithubLikeUseCase { get }
}
