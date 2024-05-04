import Combine
import Domain
import Foundation

// MARK: - GithubDetailUseCaseStub

public final class GithubDetailUseCaseStub {

  // MARK: Lifecycle

  public init() { }

  // MARK: Public

  public var type: ResponseType = .success
  public var response: Response = .init()

}

// MARK: GithubDetailUseCase

extension GithubDetailUseCaseStub: GithubDetailUseCase {
  public var repository: (GithubEntity.Detail.Repository.Request) -> AnyPublisher<
    GithubEntity.Detail.Repository.Response,
    CompositeErrorRepository
  > {
    { [weak self] _ in
      guard let self else {
        return Fail(error: CompositeErrorRepository.invalidTypeCasting)
          .eraseToAnyPublisher()
      }

      switch type {
      case .success:
        return Just(Response().repository.successValue)
          .setFailureType(to: CompositeErrorRepository.self)
          .eraseToAnyPublisher()

      case .failure(let error):
        return Fail(error: error)
          .eraseToAnyPublisher()
      }
    }
  }

  public var user: (GithubEntity.Detail.User.Request) -> AnyPublisher<
    GithubEntity.Detail.User.Response,
    CompositeErrorRepository
  > {
    { [weak self] _ in
      guard let self else {
        return Fail(error: CompositeErrorRepository.invalidTypeCasting)
          .eraseToAnyPublisher()
      }

      switch type {
      case .success:
        return Just(Response().user.successValue)
          .setFailureType(to: CompositeErrorRepository.self)
          .eraseToAnyPublisher()

      case .failure(let error):
        return Fail(error: error)
          .eraseToAnyPublisher()
      }
    }
  }

}

extension GithubDetailUseCaseStub {
  public enum ResponseType: Equatable, Sendable {
    case success
    case failure(CompositeErrorRepository)
  }

  public struct Response: Equatable, Sendable {
    public init() { }

    public var repository = DataResponseMock<GithubEntity.Detail.Repository.Response>(
      successValue: URLSerializedMockFunctor
        .serialized(url: Files.detailRepositoriesSuccessJson.url)!,
      failureValue: CompositeErrorRepository
        .remoteError(
          URLSerializedMockFunctor
            .serialized(url: Files.detailRepositoriesFailureJson.url)!))

    public var user = DataResponseMock<GithubEntity.Detail.User.Response>(
      successValue: URLSerializedMockFunctor
        .serialized(url: Files.detailUsersSuccessJson.url)!,
      failureValue: CompositeErrorRepository
        .remoteError(
          URLSerializedMockFunctor
            .serialized(url: Files.detailUsersFailureJson.url)!))

  }
}
