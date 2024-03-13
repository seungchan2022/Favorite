import Architecture
import CombineExt
import ComposableArchitecture
import Domain
import Foundation

// MARK: - UserDetailSideEffect

struct UserDetailSideEffect {
  let useCase: DashboardEnvironmentUsable
  let main: AnySchedulerOf<DispatchQueue>
  let navigator: RootNavigatorType

  init(
    useCase: DashboardEnvironmentUsable,
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
          path: Link.Dashboard.Path.follower.rawValue,
          items: item.serialized()),
        isAnimated: true)
    }
  }
}

extension GithubEntity.Detail.User.Response {
  fileprivate func serialized() -> GithubEntity.User.Follower.Request {
    .init(ownerName: loginName)
  }
}
