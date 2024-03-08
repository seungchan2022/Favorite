import Architecture
import ComposableArchitecture
import Foundation

struct LikeSideEffect {
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

extension LikeSideEffect {
  var getItemList: () -> Effect<LikeReducer.Action> {
    {
      .publisher {
        useCase.githubLikeUseCase.getItemList()
          .receive(on: main)
          .mapToResult()
          .map(LikeReducer.Action.fetchItemList)
      }
    }
  }
}
