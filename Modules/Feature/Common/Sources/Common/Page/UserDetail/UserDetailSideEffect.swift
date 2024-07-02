import Architecture
import CombineExt
import ComposableArchitecture
import Domain
import Foundation

// MARK: - UserDetailSideEffect

public struct UserDetailSideEffect {
  public let useCase: CommonEnvironmentUsable
  public let main: AnySchedulerOf<DispatchQueue>
  public let navigator: RootNavigatorType

  public init(
    useCase: CommonEnvironmentUsable,
    main: AnySchedulerOf<DispatchQueue> = .main,
    navigator: RootNavigatorType)
  {
    self.useCase = useCase
    self.main = main
    self.navigator = navigator
  }
}

extension UserDetailSideEffect {
  var user: (GithubEntity.Detail.User.Request) -> Effect<UserDetailReducer.Action> {
    { request in
      .publisher {
        useCase.githubDetailUseCase.user(request)
          .receive(on: main)
          .mapToResult()
          .map(UserDetailReducer.Action.fetchDetailItem)
      }
    }
  }

  var isLike: (GithubEntity.Detail.User.Response) -> Effect<UserDetailReducer.Action> {
    { item in
      .publisher {
        useCase.githubLikeUseCase
          .getLike()
          .map {
            $0.userList.first(where: { $0 == item }) != .none
          }
          .receive(on: main)
          .mapToResult()
          .map(UserDetailReducer.Action.fetchIsLike)
      }
    }
  }

  var updateIsLike: (GithubEntity.Detail.User.Response) -> Effect<UserDetailReducer.Action> {
    { item in
      .publisher {
        useCase.githubLikeUseCase
          .saveUser(item)
          .map {
            $0.userList.first(where: { $0 == item }) != .none
          }
          .receive(on: main)
          .mapToResult()
          .map(UserDetailReducer.Action.fetchIsLike)
      }
    }
  }

  var routeToProfile: (GithubEntity.Detail.User.Response) -> Void {
    { item in
      navigator.next(
        linkItem: .init(
          path: Link.Common.Path.profile.rawValue,
          items: item.serializedProfile()),
        isAnimated: true)
    }
  }

  var routeToFollower: (GithubEntity.Detail.User.Response) -> Void {
    { item in
      navigator.next(
        linkItem: .init(
          path: Link.Common.Path.follower.rawValue,
          items: item.serializedFollower()),
        isAnimated: true)
    }
  }
  
  var routeToBack: () -> Void {
    {
      navigator.back(isAnimated: true)
    }
  }
}

extension GithubEntity.Detail.User.Response {
  fileprivate func serializedFollower() -> GithubEntity.User.Follower.Request {
    .init(ownerName: loginName)
  }

  fileprivate func serializedProfile() -> GithubEntity.Detail.User.Request {
    .init(ownerName: loginName)
  }
}
