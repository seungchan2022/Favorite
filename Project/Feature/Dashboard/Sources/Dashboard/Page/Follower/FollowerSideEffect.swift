import Architecture
import ComposableArchitecture
import Foundation
import Domain

struct FollowerSideEffect {
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
}
