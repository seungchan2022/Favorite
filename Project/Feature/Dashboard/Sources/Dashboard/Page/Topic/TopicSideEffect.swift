import Architecture
import CombineExt
import ComposableArchitecture
import Domain
import Foundation

// MARK: - TopicSideEffect

struct TopicSideEffect {
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

extension TopicSideEffect {
  var searchTopic: (GithubEntity.Search.Topic.Request) -> Effect<TopicStore.Action> {
    { item in
      .publisher {
        useCase.githubSearchUseCase.searchTopic(item)
          .receive(on: main)
          .mapToResult()
          .map(TopicStore.Action.fetchSearchItem)
      }
    }
  }
}
