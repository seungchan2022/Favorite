import Architecture
import Domain

public protocol LikeEnvironmentUsable {
  var toastViewModel: ToastViewActionType { get }
  var githubSearchUseCase: GithubSearchUseCase { get }
  var githubDetailUseCase: GithubDetailUseCase { get }
  var githubLikeUseCase: GithubLikeUseCase { get }
  var githubUserUseCase: GithubUserUseCase { get }
}
