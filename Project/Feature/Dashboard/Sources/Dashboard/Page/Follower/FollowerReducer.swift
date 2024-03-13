import Architecture
import ComposableArchitecture
import Dispatch
import Foundation

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
    
    init(id: UUID = UUID()) {
      self.id = id
    }
  }
  
  enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case teardown
  }
  
  enum CancelID: Equatable, Codable {
    case teardown
  }
  
  var body: some Reducer<State, Action> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
      case .teardown:
        return .none
      }
    }
  }
}
