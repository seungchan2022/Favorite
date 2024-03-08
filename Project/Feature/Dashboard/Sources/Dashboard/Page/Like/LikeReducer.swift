import ComposableArchitecture
import Dispatch
import Foundation
import Architecture
import Domain

enum LikeList: String {
  case repoList = "RepoList"
  case userList = "UserList"
}

@Reducer
struct LikeReducer {

  // MARK: Lifecycle

  init(
    pageID: String = UUID().uuidString,
    sideEffect: LikeSideEffect)
  {
    self.pageID = pageID
    self.sideEffect = sideEffect
  }

  // MARK: Internal

  @ObservableState
  struct State: Equatable, Identifiable {
    let id: UUID
    var selectedLikeList: LikeList = .repoList
    var itemList: GithubEntity.Like = .init()
    var fetchItemList: FetchState.Data<GithubEntity.Like?> = .init(isLoading: false, value: .none)

    init(id: UUID = UUID()) {
      self.id = id
    }
  }

  enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case teardown
    
    case getItemList
    case fetchItemList(Result<GithubEntity.Like, CompositeErrorRepository>)
    
    case throwError(CompositeErrorRepository)
  }

  enum CancelID: Equatable, CaseIterable {
    case teardown
    case requestRepoList
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
        
      case .getItemList:
        state.fetchItemList.isLoading = true
        return sideEffect.getItemList()
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
