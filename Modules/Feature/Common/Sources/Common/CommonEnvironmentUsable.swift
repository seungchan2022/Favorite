import Architecture
import Domain

public protocol CommonEnvironmentUsable {
  var toastViewModel: ToastViewActionType { get }
  var githubDetailUseCase: GithubDetailUseCase { get }
  var githubLikeUseCase: GithubLikeUseCase { get }
  var githubUserUseCase: GithubUserUseCase { get }
}
