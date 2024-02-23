import Architecture
import ComposableArchitecture
import Dispatch
import Domain
import Foundation

@Reducer
struct TopicStore {
  
  private let pageID: String
  private let sideEffect: TopicSideEffect
  
  init(
    pageID: String = UUID().uuidString,
    sideEffect: TopicSideEffect)
  {
    self.pageID = pageID
    self.sideEffect = sideEffect
  }
  
  @ObservableState
  struct State: Equatable {
    let id: UUID
    
    init(id: UUID = UUID()) {
      self.id = id
    }
  }
  
  var body: some Reducer<State, Action> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
      case .throwError(let error):
        sideEffect.useCase.toastViewModel.send(errorMessage: error.displayMessage)
        return .none
        
      case .teardown:
        return .concatenate(
          CancelID.allCases.map { .cancel(pageID: pageID, id: $0) })
      }
    }
  }
  
  enum Action: BindableAction, Sendable {
    case binding(BindingAction<State>)
    
    
    case throwError(CompositeErrorRepository)
    case teardown
  }
  
  enum CancelID: Equatable, CaseIterable {
    case teardown
  }
}
