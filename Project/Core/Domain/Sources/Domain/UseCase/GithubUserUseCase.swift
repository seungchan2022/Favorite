import Combine

public protocol GithubUserUseCase {
  var getFollower: (GithubEntity.User.Follower.Request) -> AnyPublisher<
    [GithubEntity.User.Follower.Response],
    CompositeErrorRepository
  > { get }
}
