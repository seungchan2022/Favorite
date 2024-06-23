import Architecture
import ComposableArchitecture
import Domain
import Foundation

// MARK: - ProfileSideEffect

public struct ProfileSideEffect {
  public let useCase: LikeEnvironmentUsable
  public let main: AnySchedulerOf<DispatchQueue>
  public let navigator: RootNavigatorType

  public init(
    useCase: LikeEnvironmentUsable,
    main: AnySchedulerOf<DispatchQueue> = .main ,
    navigator: RootNavigatorType)
  {
    self.useCase = useCase
    self.main = main
    self.navigator = navigator
  }
}

extension ProfileSideEffect {
  var item: (GithubEntity.Detail.User.Request) -> Effect<ProfileReducer.Action> {
    { item in
      .publisher {
        useCase.githubDetailUseCase.user(item)
          .receive(on: main)
          .mapToResult()
          .map(ProfileReducer.Action.fetchItem)
      }
    }
  }

  var isLike: (GithubEntity.Detail.User.Response) -> Effect<ProfileReducer.Action> {
    { item in
      .publisher {
        useCase.githubLikeUseCase.getLike()
          .map {
            $0.userList.first(where: { $0 == item }) != .none
          }
          .receive(on: main)
          .mapToResult()
          .map(ProfileReducer.Action.fetchIsLike)
      }
    }
  }

  var updateIsLike: (GithubEntity.Detail.User.Response) -> Effect<ProfileReducer.Action> {
    { item in
      .publisher {
        useCase.githubLikeUseCase.saveUser(item)
          .map {
            $0.userList.first(where: { $0 == item }) != .none
          }
          .receive(on: main)
          .mapToResult()
          .map(ProfileReducer.Action.fetchIsLike)
      }
    }
  }
}
