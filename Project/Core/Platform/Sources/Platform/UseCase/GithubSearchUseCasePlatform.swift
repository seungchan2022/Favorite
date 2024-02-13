import Combine
import Domain

public struct GithubSearchUseCasePlatform {
  let baseURL: String
  
  public init(baseURL: String = "https://api.github.com") {
    self.baseURL = baseURL
  }
}

extension GithubSearchUseCasePlatform: GithubSearchUseCase {
  public var search: (GithubEntity.Search.Repository.Request) -> AnyPublisher<GithubEntity.Search.Repository.Response, CompositeErrorRepository> {
    {
      Endpoint(
        baseURL: baseURL,
        pathList: ["search", "repositories"],
        httpMethod: .get, 
        content: .queryItemPath($0))
      .fetch(isDebug: true)
    }
  }
}
