import Combine
import Domain

// MARK: - GithubLikeUseCasePlatform

public struct GithubLikeUseCasePlatform {
  @StandardKeyArchiver(defaultValue: GithubEntity.Like())
  private var store: GithubEntity.Like
  
  public init() { }
}

// MARK: GithubLikeUseCase

extension GithubLikeUseCasePlatform: GithubLikeUseCase {
  public var getLike: () -> AnyPublisher<GithubEntity.Like, CompositeErrorRepository> {
    {
      return Just(store)
        .setFailureType(to: CompositeErrorRepository.self)
        .eraseToAnyPublisher()
    }
  }
  
  public var saveRepository: (GithubEntity.Detail.Repository.Response) -> AnyPublisher<
    GithubEntity.Like,
    CompositeErrorRepository
  > {
    { model in
      _store.sync(store.mutateRepo(item: model))
      return Just(store)
        .setFailureType(to: CompositeErrorRepository.self)
        .eraseToAnyPublisher()
    }
  }
  
  public var saveUser: (GithubEntity.Detail.User.Response) -> AnyPublisher<GithubEntity.Like, CompositeErrorRepository> {
    { model in
      _store.sync(store.mutateUser(item: model))
      return Just(store)
        .setFailureType(to: CompositeErrorRepository.self)
        .eraseToAnyPublisher()
    }
  }
  
  public var getItemList: () -> AnyPublisher<GithubEntity.Like, CompositeErrorRepository> {
    {
      print("AAA: ", store.repoList)
      print("BBB: ", store.userList)
      return Just(store)
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
