import Architecture
import ComposableArchitecture
import Dispatch
import Domain
import Foundation

// MARK: - LikeList

public enum LikeList: String {
  case repoList = "RepoList"
  case userList = "UserList"
}

// MARK: - LikeReducer

@Reducer
public struct LikeReducer {

  // MARK: Lifecycle

  public init(
    pageID: String = UUID().uuidString,
    sideEffect: LikeSideEffect)
  {
    self.pageID = pageID
    self.sideEffect = sideEffect
  }

  // MARK: Internal

  @ObservableState
  public struct State: Equatable, Identifiable {
    public let id: UUID
    public var selectedLikeList: LikeList = .repoList
    public var itemList: GithubEntity.Like = .init()
    public var fetchItemList: FetchState.Data<GithubEntity.Like?> = .init(isLoading: false, value: .none)

    public init(id: UUID = UUID()) {
      self.id = id
    }
  }

  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case teardown

    case getItemList
    case fetchItemList(Result<GithubEntity.Like, CompositeErrorRepository>)

    case routeToRepoDetail(GithubEntity.Detail.Repository.Response)
    case routeToUserDetail(GithubEntity.Detail.User.Response)

    case throwError(CompositeErrorRepository)
  }

  enum CancelID: Equatable, CaseIterable {
    case teardown
    case requestRepoList
  }

  public var body: some Reducer<State, Action> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .binding:
        return .none

      case .teardown:
        return .concatenate(
          CancelID.allCases.map { .cancel(pageID: pageID, id: $0) })

      case .getItemList:
        state.fetchItemList.isLoading = true
        return sideEffect
          .getItemList()
          .cancellable(pageID: pageID, id: CancelID.requestRepoList, cancelInFlight: true)

      case .fetchItemList(let result):
        state.fetchItemList.isLoading = false
        switch result {
        case .success(let list):
          state.fetchItemList.value = list
          state.itemList = list
          return .none

        case .failure(let error):
          return .run { await $0(.throwError(error)) }
        }

      case .routeToRepoDetail(let item):
        sideEffect.routeToRepoDetail(item)
        return .none

      case .routeToUserDetail(let item):
        sideEffect.routeToUserDetail(item)
        return .none

      case .throwError(let error):
        sideEffect.useCase.toastViewModel.send(errorMessage: error.displayMessage)
        return .none
      }
    }
  }

  // MARK: Private

  private let pageID: String
  private let sideEffect: LikeSideEffect
}
