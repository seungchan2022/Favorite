import Combine
import Domain

// MARK: - GithubdetailUseCasePlatform

public struct GithubDetailUseCasePlatform {
  let baseURL: String

  public init(baseURL: String = "https://api.github.com") {
    self.baseURL = baseURL
  }
}

// MARK: GithubDetailUseCase

extension GithubDetailUseCasePlatform: GithubDetailUseCase {
  public var repository: (GithubEntity.Detail.Repository.Request) -> AnyPublisher<
    GithubEntity.Detail.Repository.Response,
    CompositeErrorRepository
  > {
    { item in
      Endpoint(
        baseURL: baseURL,
        pathList: ["repos", item.ownerName, item.repositoryname],
        httpMethod: .get,
        content: .none)
        .fetch(isDebug: true)
    }
  }
  
  public var user: (GithubEntity.Detail.User.Request) -> AnyPublisher<GithubEntity.Detail.User.Response, CompositeErrorRepository> {
    { item in
      Endpoint(
        baseURL: baseURL,
        pathList: ["users", item.login],
        httpMethod: .get,
        content: .none)
      .fetch(isDebug: true)
    }
  }
}
