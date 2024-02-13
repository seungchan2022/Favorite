import Combine

public protocol GithubSearchUseCase {
  var search: (GithubEntity.Search.Repository.Request) -> AnyPublisher<GithubEntity.Search.Repository.Response, CompositeErrorRepository> { get }
}
