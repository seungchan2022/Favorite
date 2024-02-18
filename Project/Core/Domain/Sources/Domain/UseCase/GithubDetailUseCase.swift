import Combine

public protocol GithubDetailUseCase {


  var userProfile: (String) -> AnyPublisher<GithubEntity.Detail.Profile.Item, CompositeErrorRepository> { get }
}
