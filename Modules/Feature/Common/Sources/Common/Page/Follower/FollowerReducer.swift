import Architecture
import ComposableArchitecture
import Dispatch
import Domain
import Foundation

// MARK: - FollowerReducer

@Reducer
public struct FollowerReducer {

  // MARK: Lifecycle

  public init(
    pageID: String = UUID().uuidString,
    sideEffect: FollowerSideEffect)
  {
    self.pageID = pageID
    self.sideEffect = sideEffect
  }

  // MARK: Public

  @ObservableState
  public struct State: Equatable, Identifiable {
    public let id: UUID
    public var item: GithubEntity.User.Follower.Request
    public var itemList: [GithubEntity.User.Follower.Response] = []
    public var fetchItem: FetchState.Data<[GithubEntity.User.Follower.Response?]> = .init(isLoading: false, value: [])

    public init(
      id: UUID = UUID(),
      item: GithubEntity.User.Follower.Request)
    {
      self.id = id
      self.item = item
    }
  }

  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case teardown

    case getItem(GithubEntity.User.Follower.Request)
    case fetchItem(Result<[GithubEntity.User.Follower.Response], CompositeErrorRepository>)

    case routeToUser(GithubEntity.User.Follower.Response)
    case routeToBack

    case throwError(CompositeErrorRepository)
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

      case .getItem(let requestModel):
        state.fetchItem.isLoading = true
        return sideEffect.follower(requestModel)
          .cancellable(pageID: pageID, id: CancelID.requestItem, cancelInFlight: true)

      case .fetchItem(let result):
        state.fetchItem.isLoading = false
        switch result {
        case .success(let list):
          state.fetchItem.value = list
          state.itemList = state.itemList.merge(list)
          return .none

        case .failure(let error):
          return .run { await $0(.throwError(error)) }
        }

      case .routeToUser(let item):
        sideEffect.routeToUser(item)
        return .none
        
      case .routeToBack:
        sideEffect.routeToBack()
        return .none

      case .throwError(let error):
        sideEffect.useCase.toastViewModel.send(errorMessage: error.displayMessage)
        return .none
      }
    }
  }

  // MARK: Internal

  enum CancelID: Equatable, CaseIterable {
    case teardown
    case requestItem
  }

  // MARK: Private

  private let pageID: String
  private let sideEffect: FollowerSideEffect
}

extension [GithubEntity.User.Follower.Response] {
  fileprivate func merge(_ targer: Self) -> Self {
    let new = targer.reduce(self) { curr, next in
      guard !self.contains(where: { $0.id == next.id }) else { return curr }
      return curr + [next]
    }

    return new
  }
}
