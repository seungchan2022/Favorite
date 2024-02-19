import Combine
import Domain

// MARK: - GithubdetailUseCasePlatform

public struct GithubdetailUseCasePlatform {
  let baseURL: String

  public init(baseURL: String = "https://api.github.com") {
    self.baseURL = baseURL
  }
}

// MARK: GithubDetailUseCase

extension GithubdetailUseCasePlatform: GithubDetailUseCase {
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

  public var userProfile: (String) -> AnyPublisher<GithubEntity.Detail.Profile.Item, CompositeErrorRepository> {
    {
      Endpoint(
        baseURL: baseURL,
        pathList: ["users", $0],
        httpMethod: .get,
        content: .queryItemPath($0))
        .fetch(isDebug: true)
    }
  }
}
