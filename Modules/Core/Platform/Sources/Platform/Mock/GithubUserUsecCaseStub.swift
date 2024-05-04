import Combine
import Domain
import Foundation

// MARK: - GithubUserUsecCaseStub

public final class GithubUserUsecCaseStub {

  // MARK: Lifecycle

  public init() { }

  // MARK: Public

  public var type: ResponseType = .success
  public var response: Response = .init()
}

// MARK: GithubUserUseCase

extension GithubUserUsecCaseStub: GithubUserUseCase {
  public var getFollower: (GithubEntity.User.Follower.Request) -> AnyPublisher<
    [GithubEntity.User.Follower.Response],
    CompositeErrorRepository
  > {
    { [weak self] _ in
      guard let self else {
        return Fail(error: CompositeErrorRepository.invalidTypeCasting).eraseToAnyPublisher()
      }

      switch type {
      case .success:
        return Just(Response().follower.successValue)
          .setFailureType(to: CompositeErrorRepository.self)
          .eraseToAnyPublisher()

      case .failure(let error):
        return Fail(error: error)
          .eraseToAnyPublisher()
      }
    }
  }
}

extension GithubUserUsecCaseStub {
  public enum ResponseType: Equatable, Sendable {
    case success
    case failure(CompositeErrorRepository)
  }

  public struct Response: Equatable, Sendable {
    public init() { }

    public var follower = DataResponseMock<[GithubEntity.User.Follower.Response]>(
      successValue: URLSerializedMockFunctor
        .serialized(url: Files.userFollowersSuccessJson.url)!,
      failureValue: CompositeErrorRepository
        .remoteError(
          URLSerializedMockFunctor
            .serialized(url: Files.userFollowersFailureJson.url)!))
  }
}
