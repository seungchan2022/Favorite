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
  var detail: (GithubEntity.Detail.User.Request) -> Effect<UserDetailReducer.Action> {
    { item in
      .publisher {
        useCase.githubDetailUseCase.user(item)
          .receive(on: main)
          .mapToResult()
          .map(UserDetailReducer.Action.fetchDetailItem)
      }
    }
  }
}
