import Architecture
import CombineExt
import ComposableArchitecture
import Domain
import Foundation

// MARK: - UserSideEffect

struct UserSideEffect {
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

extension UserSideEffect {
  var searchUser: (GithubEntity.Search.User.Request) -> Effect<UserStore.Action> {
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
          .map(UserStore.Action.fetchSearchItem)
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
    .init(login: login)
  }
}
