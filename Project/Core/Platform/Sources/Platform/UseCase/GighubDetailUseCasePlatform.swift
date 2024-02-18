import Combine
import Domain

// MARK: - GithubSearchUseCasePlatform

public struct GithubdetailUseCasePlatform {
  let baseURL: String

  public init(baseURL: String = "https://api.github.com") {
    self.baseURL = baseURL
  }
}

// MARK: GithubSearchUseCase

extension GithubdetailUseCasePlatform: GithubDetailUseCase {
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
