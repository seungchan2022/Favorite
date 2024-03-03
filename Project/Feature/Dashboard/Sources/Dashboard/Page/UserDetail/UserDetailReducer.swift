import Architecture
import ComposableArchitecture
import Dispatch
import Domain
import Foundation

@Reducer
struct UserDetailReducer {

  // MARK: Lifecycle

  init(
    pageID: String = UUID().uuidString,
    sideEffect: UserDetailSideEffect)
  {
    self.pageID = pageID
    self.sideEffect = sideEffect
  }

  // MARK: Internal

  @ObservableState
  struct State: Equatable, Identifiable {
    let id: UUID
    var item: GithubEntity.Detail.User.Request
    var fetchDetailItem: FetchState.Data<GithubEntity.Detail.User.Response?> = .init(isLoading: false, value: .none)

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

    case getDetail
    case fetchDetailItem(Result<GithubEntity.Detail.User.Response, CompositeErrorRepository>)

    case throwError(CompositeErrorRepository)

    case teardown
  }

  enum CancelID: Equatable, CaseIterable {
    case teardown
    case requestDetail
  }

  var body: some Reducer<State, Action> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .binding:
        return .none

      case .getDetail:
        state.fetchDetailItem.isLoading = true
        return sideEffect.detail(state.item)
          .cancellable(pageID: pageID, id: CancelID.requestDetail, cancelInFlight: true)

      case .fetchDetailItem(let result):
        state.fetchDetailItem.isLoading = false
        switch result {
        case .success(let item):
          state.fetchDetailItem.value = item
          return .none

        case .failure(let error):
          return .run { await $0(.throwError(error)) }
        }

      case .throwError(let error):
        sideEffect.useCase.toastViewModel.send(errorMessage: error.displayMessage)
        return .none

      case .teardown:
        return .concatenate(
          CancelID.allCases.map { .cancel(pageID: pageID, id: $0) })
      }
    }
  }

  // MARK: Private

  private let pageID: String
  private let sideEffect: UserDetailSideEffect
}
