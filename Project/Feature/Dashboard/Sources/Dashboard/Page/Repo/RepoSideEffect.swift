import Architecture
import ComposableArchitecture
import Foundation
import Domain
import CombineExt

struct RepoSideEffect {
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

extension RepoSideEffect {
  var searchRepository: (GithubEntity.Search.Repository.Request) -> Effect<RepoStore.Action> {
    { item in
        .publisher {
          useCase.githubSearchUsecase.searchRepository(item)
            .receive(on: main)
            .map {
              GithubEntity.Search.Repository.Composite(
                request: item,
                response: $0)
            }
            .mapToResult()
            .map(RepoStore.Action.fetchSearchItem)
        }
    }
  }
}
