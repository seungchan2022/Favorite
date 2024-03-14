import Architecture
import ComposableArchitecture
import Domain
import Foundation

@Reducer
struct ProfileReducer {

  // MARK: Lifecycle

  init(
    pageID: String = UUID().uuidString,
    sideEffect: ProfileSideEffect)
  {
    self.pageID = pageID
    self.sideEffect = sideEffect
  }

  // MARK: Internal

  @ObservableState
  struct State: Equatable, Identifiable {
    let id: UUID
    let item: GithubEntity.Detail.User.Request

    var fetchItem: FetchState.Data<GithubEntity.Detail.User.Response?> = .init(isLoading: false, value: .none)
    var fetchIsLike: FetchState.Data<Bool> = .init(isLoading: false, value: false)

    init(
      id: UUID = UUID(),
      item: GithubEntity.Detail.User.Request)
    {
      self.id = id
      self.item = item
    }
  }

  enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case teardown
    case getItem
    case getIsLike(GithubEntity.Detail.User.Response?)
    case updateIsLike(GithubEntity.Detail.User.Response)
    case fetchItem(Result<GithubEntity.Detail.User.Response, CompositeErrorRepository>)
    case fetchIsLike(Result<Bool, CompositeErrorRepository>)

    case throwError(CompositeErrorRepository)
  }

  enum CancelID: Equatable, CaseIterable {
    case teardown
    case requestItem
    case requestIsLike
  }

  var body: some Reducer<State, Action> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .binding:
        return .none

      case .teardown:
        return .concatenate(
          CancelID.allCases.map { .cancel(pageID: pageID, id: $0) })

      case .getItem:
        state.fetchItem.isLoading = true
        return sideEffect.item(state.item)
          .cancellable(pageID: pageID, id: CancelID.requestItem, cancelInFlight: true)

      case .getIsLike(let item):
        guard let item else { return .none }
        state.fetchIsLike.isLoading = true
        return sideEffect.isLike(item)
          .cancellable(pageID: pageID, id: CancelID.requestIsLike, cancelInFlight: true)

      case .updateIsLike(let item):
        state.fetchIsLike.isLoading = true
        return sideEffect.updateIsLike(item)
          .cancellable(pageID: pageID, id: CancelID.requestIsLike, cancelInFlight: true)

      case .fetchItem(let result):
        state.fetchItem.isLoading = false
        switch result {
        case .success(let item):
          state.fetchItem.value = item
          return .none

        case .failure(let error):
          return .run { await $0(.throwError(error)) }
        }

      case .fetchIsLike(let result):
        state.fetchIsLike.isLoading = false
        switch result {
        case .success(let item):
          state.fetchIsLike.value = item
          return .none

        case .failure(let error):
          return .run { await $0(.throwError(error)) }
        }

      case .throwError(let error):
        sideEffect.useCase.toastViewModel.send(errorMessage: error.displayMessage)
        return .none
      }
    }
  }

  // MARK: Private

  private let pageID: String
  private let sideEffect: ProfileSideEffect
}
