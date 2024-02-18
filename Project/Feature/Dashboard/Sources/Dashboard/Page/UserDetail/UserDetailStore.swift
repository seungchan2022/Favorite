import Architecture
import ComposableArchitecture
import Dispatch
import Domain
import Foundation

@Reducer
struct UserDetailStore {

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
    var name = "seungchan2022"
    var UserDetailItem: GithubEntity.Detail.Profile.Item? = .none

    var fetchUserDetailItem: FetchState.Data<GithubEntity.Detail.Profile.Item?> = .init(isLoading: false, value: .none)

    init(id: UUID = UUID()) {
      self.id = id
    }
  }

  enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case getUserDetailItem(String)
    case fetchUserDetailItem(Result<GithubEntity.Detail.Profile.Item, CompositeErrorRepository>)
    case throwError(CompositeErrorRepository)

    case teardown
  }

  enum CancelID: Equatable, CaseIterable {
    case teardown
    case requestUserDetail
  }

  var body: some Reducer<State, Action> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .binding:
        return .none

      case .getUserDetailItem(let user):
        state.fetchUserDetailItem.isLoading = true
        return sideEffect.userUserDetail(user)
          .cancellable(pageID: pageID, id: CancelID.requestUserDetail, cancelInFlight: true)

      case .fetchUserDetailItem(let result):
        state.fetchUserDetailItem.isLoading = false

        switch result {
        case .success(let item):
          state.fetchUserDetailItem.value = item
          state.UserDetailItem = item

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
