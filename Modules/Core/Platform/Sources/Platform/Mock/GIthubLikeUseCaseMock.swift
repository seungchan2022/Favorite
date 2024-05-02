import Combine
import Domain

// MARK: - GithubLikeUseCaseMock

public class GithubLikeUseCaseMock {

  // MARK: Lifecycle

  public init(store: GithubEntity.Like = .init()) {
    self.store = store
  }

  // MARK: Public

  public func reset(store: GithubEntity.Like = .init()) {
    self.store = store
  }

  // MARK: Private

  private var store: GithubEntity.Like
}

// MARK: GithubLikeUseCase

extension GithubLikeUseCaseMock: GithubLikeUseCase {
  public var getLike: () -> AnyPublisher<GithubEntity.Like, CompositeErrorRepository> {
    {
      Just(self.store)
        .setFailureType(to: CompositeErrorRepository.self)
        .eraseToAnyPublisher()
    }
  }

  public var saveRepository: (GithubEntity.Detail.Repository.Response) -> AnyPublisher<
    GithubEntity.Like,
    CompositeErrorRepository
  > {
    { model in
      self.store = self.store.mutateRepo(item: model)
      return Just(self.store)
        .setFailureType(to: CompositeErrorRepository.self)
        .eraseToAnyPublisher()
    }
  }

  public var saveUser: (GithubEntity.Detail.User.Response) -> AnyPublisher<GithubEntity.Like, CompositeErrorRepository> {
    { model in
      self.store = self.store.mutateUser(item: model)
      return Just(self.store)
        .setFailureType(to: CompositeErrorRepository.self)
        .eraseToAnyPublisher()
    }
  }

  public var getItemList: () -> AnyPublisher<GithubEntity.Like, CompositeErrorRepository> {
    {
      Just(self.store)
        .setFailureType(to: CompositeErrorRepository.self)
        .eraseToAnyPublisher()
    }
  }
}

extension GithubEntity.Like {
  fileprivate func mutateRepo(item: GithubEntity.Detail.Repository.Response) -> Self {
    guard repoList.first(where: { $0.htmlURL == item.htmlURL }) != .none else {
      return .init(
        repoList: repoList + [item],
        userList: userList)
    }

    return .init(
      repoList: repoList.filter { $0.htmlURL != item.htmlURL },
      userList: userList)
  }

  fileprivate func mutateUser(item: GithubEntity.Detail.User.Response) -> Self {
    guard userList.first(where: { $0.htmlURL == item.htmlURL }) != .none else {
      return .init(
        repoList: repoList,
        userList: userList + [item])
    }

    return .init(
      repoList: repoList,
      userList: userList.filter { $0.htmlURL != item.htmlURL })
  }
}
