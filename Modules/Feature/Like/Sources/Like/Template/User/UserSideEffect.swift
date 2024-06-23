import Architecture
import CombineExt
import ComposableArchitecture
import Domain
import Foundation

// MARK: - UserSideEffect

public struct UserSideEffect {
  public let useCase: LikeEnvironmentUsable
  public let main: AnySchedulerOf<DispatchQueue>
  public let navigator: RootNavigatorType

  public init(
    useCase: LikeEnvironmentUsable,
    main: AnySchedulerOf<DispatchQueue> = .main,
    navigator: RootNavigatorType)
  {
    self.useCase = useCase
    self.main = main
    self.navigator = navigator
  }
}

extension UserSideEffect {
  var searchUser: (GithubEntity.Search.User.Request) -> Effect<UserReducer.Action> {
    { item in
      .publisher {
        useCase.githubSearchUseCase.searchUser(item)
          .receive(on: main)
          .map {
            GithubEntity.Search.User.Composite(
              request: item,
              response: $0)
          }
          .mapToResult()
          .map(UserReducer.Action.fetchSearchItem)
      }
    }
  }

  var routeToDetail: (GithubEntity.Search.User.Item) -> Void {
    { item in
      navigator.next(
        linkItem: .init(
          path: Link.Dashboard.Path.userDetail.rawValue,
          items: item.serialized()),
        isAnimated: true)
    }
  }
}

extension GithubEntity.Search.User.Item {
  fileprivate func serialized() -> GithubEntity.Detail.User.Request {
    .init(ownerName: login)
  }
}
