import Architecture
import ComposableArchitecture
import Domain
import Foundation

// MARK: - FollowerSideEffect

public struct FollowerSideEffect {
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

extension FollowerSideEffect {
  var follower: (GithubEntity.User.Follower.Request) -> Effect<FollowerReducer.Action> {
    { request in
      .publisher {
        useCase.githubUserUseCase.getFollower(request)
          .receive(on: main)
          .mapToResult()
          .map(FollowerReducer.Action.fetchItem)
      }
    }
  }

  var routeToUser: (GithubEntity.User.Follower.Response) -> Void {
    { item in
      navigator.next(
        linkItem: .init(
          path: Link.Common.Path.userDetail.rawValue,
          items: item.serialized()),
        isAnimated: true)
    }
  }
}

extension GithubEntity.User.Follower.Response {
  fileprivate func serialized() -> GithubEntity.Detail.User.Request {
    .init(ownerName: login)
  }
}
