import Architecture
import CombineExt
import ComposableArchitecture
import Domain
import Foundation

// MARK: - RepoDetailSideEffect

public struct RepoDetailSideEffect {
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

extension RepoDetailSideEffect {
  var detail: (GithubEntity.Detail.Repository.Request) -> Effect<RepoDetailReducer.Action> {
    { item in
      .publisher {
        useCase.githubDetailUseCase.repository(item)
          .receive(on: main)
          .mapToResult()
          .map(RepoDetailReducer.Action.fetchDetailItem)
      }
    }
  }

  var isLike: (GithubEntity.Detail.Repository.Response) -> Effect<RepoDetailReducer.Action> {
    { item in
      .publisher {
        useCase.githubLikeUseCase
          .getLike()
          .map {
            $0.repoList.first(where: { $0 == item }) != .none
          }
          .receive(on: main)
          .mapToResult()
          .map(RepoDetailReducer.Action.fetchIsLike)
      }
    }
  }

  var updateIsLike: (GithubEntity.Detail.Repository.Response) -> Effect<RepoDetailReducer.Action> {
    { item in
      .publisher {
        useCase.githubLikeUseCase
          .saveRepository(item)
          .map {
            $0.repoList.first(where: { $0 == item }) != .none
          }
          .receive(on: main)
          .mapToResult()
          .map(RepoDetailReducer.Action.fetchIsLike)
      }
    }
  }

  var routeToBack: () -> Void {
    {
      navigator.back(isAnimated: true)
    }
  }
}
