import Architecture
import ComposableArchitecture
import Dispatch
import Foundation
import Domain

@Reducer
struct FollowerReducer {
  
  private let pageID: String
  private let sideEffect: FollowerSideEffect
  
  init(
    pageID: String = UUID().uuidString,
    sideEffect: FollowerSideEffect) {
    self.pageID = pageID
    self.sideEffect = sideEffect
  }
  
  @ObservableState
  struct State: Equatable, Identifiable {
    let id: UUID
    var item: GithubEntity.User.Follower.Request
    var itemList: [GithubEntity.User.Follower.Response] = []
    var fetchItem: FetchState.Data<[GithubEntity.User.Follower.Response?]> = .init(isLoading: false, value: [])
    
    init(
      id: UUID = UUID(),
      item: GithubEntity.User.Follower.Request)
    {
      self.id = id
      self.item = item
    }
  }
  
  enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case teardown
    
    case getItem(GithubEntity.User.Follower.Request)
    case fetchItem(Result<[GithubEntity.User.Follower.Response], CompositeErrorRepository>)
    
    case throwError(CompositeErrorRepository)
  }
  
  enum CancelID: Equatable, CaseIterable {
    case teardown
    case requestItem
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
        
      case .getItem(let requestModel):
        state.fetchItem.isLoading = true
        return sideEffect.follower(requestModel)
          .cancellable(pageID: pageID, id: CancelID.requestItem, cancelInFlight: true)
        
      case .fetchItem(let result):
        state.fetchItem.isLoading = false
        switch result {
        case .success(let list):
          state.fetchItem.value = list
          state.itemList = state.itemList + list
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
}
