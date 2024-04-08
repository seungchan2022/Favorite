import Combine

public protocol GithubSearchUseCase {
  var searchRepository: (GithubEntity.Search.Repository.Request) -> AnyPublisher<
    GithubEntity.Search.Repository.Response,
    CompositeErrorRepository
  > { get }

  var searchUser: (GithubEntity.Search.User.Request)
    -> AnyPublisher<GithubEntity.Search.User.Response, CompositeErrorRepository> { get }

  var searchTopic: (GithubEntity.Search.Topic.Request) -> AnyPublisher<
    GithubEntity.Search.Topic.Response,
    CompositeErrorRepository
  > { get }
}
