import Combine
import Domain

public struct GithubUserUseCasePlatform {
  let baseURL: String

  public init(baseURL: String = "https://api.github.com") {
    self.baseURL = baseURL
  }
}

extension GithubUserUseCasePlatform: GithubUserUseCase {
  public var getFollower: (GithubEntity.User.Follower.Request) -> AnyPublisher<[GithubEntity.User.Follower.Response], CompositeErrorRepository> {
    { item in
      Endpoint(
        baseURL: baseURL,
        pathList: ["users", item.ownerName, "followers"],
        httpMethod: .get,
        content: .none)
      .fetch(isDebug: true)
    }
  }
}
