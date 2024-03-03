import Architecture
import CombineExt
import ComposableArchitecture
import Domain
import Foundation

// MARK: - RepoSideEffect

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
  var searchRepository: (GithubEntity.Search.Repository.Request) -> Effect<RepoReducer.Action> {
    { item in
      .publisher {
        useCase.githubSearchUseCase.searchRepository(item)
          .receive(on: main)
          .map {
            GithubEntity.Search.Repository.Composite(
              request: item,
              response: $0)
          }
          .mapToResult()
          .map(RepoReducer.Action.fetchSearchItem)
      }
    }
  }

  var routeToDeatil: (GithubEntity.Search.Repository.Item) -> Void {
    { item in
      navigator.next(
        linkItem: .init(
          path: Link.Dashboard.Path.repoDetail.rawValue,
          items: item.serialized()),
        isAnimated: true)
    }
  }
}

extension GithubEntity.Search.Repository.Item {
  fileprivate func serialized() -> GithubEntity.Detail.Repository.Request {
    .init(ownerName: owner.login, repositoryname: name)
  }
}
