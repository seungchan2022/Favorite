import ComposableArchitecture
import Dispatch
import Domain
import Architecture
import Foundation

@Reducer
struct ProfileStore {
  
  private let pageID: String
  private let sideEffect: ProfileSideEffect
  
  init(
    pageID: String = UUID().uuidString,
    sideEffect: ProfileSideEffect)
  {
    self.pageID = pageID
    self.sideEffect = sideEffect
  }
  
  @ObservableState
  struct State: Equatable, Identifiable {
    let id: UUID
    var name: String = "seungchan2022"
    var profileItem: GithubEntity.Profile.Item? = .none
    
    var fetchProfileItem: FetchState.Data<GithubEntity.Profile.Item?> = .init(isLoading: false, value: .none)
    
    
    init(id: UUID = UUID()) {
      self.id = id
    }
  }
  
  enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case getProfileItem(String)
    case fetchProfileItem(Result<GithubEntity.Profile.Item, CompositeErrorRepository>)
    case throwError(CompositeErrorRepository)
    
    case teardown
  }
  
  var body: some Reducer<State, Action> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
      case .getProfileItem(let user):
        state.fetchProfileItem.isLoading = true
        return sideEffect.userProfile(user)
          .cancellable(pageID: pageID, id: CancelID.requestProfile, cancelInFlight: true)
         
      case .fetchProfileItem(let result):
        print(result)
        state.fetchProfileItem.isLoading = false
        
        switch result {
        case .success(let item):
          state.fetchProfileItem.value = item
          state.profileItem = item

          return .none
          
        case .failure(let error):
          return .run { await $0(.throwError(error))}
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
  
  
  enum CancelID: Equatable, CaseIterable {
    case teardown
    case requestProfile
  }
}
