import Architecture
import ComposableArchitecture
import Dispatch
import Domain
import Foundation

@Reducer
struct TopicStore {
  
  // MARK: Lifecycle
  
  init(
    pageID: String = UUID().uuidString,
    sideEffect: TopicSideEffect)
  {
    self.pageID = pageID
    self.sideEffect = sideEffect
  }
  
  // MARK: Internal
  
  @ObservableState
  struct State: Equatable, Identifiable {
    let id: UUID
    var query = "swift"
    var itemList: [GithubEntity.Search.Topic.Item] = []
    
    var fetchSearchItem: FetchState.Data<GithubEntity.Search.Topic.Response?> = .init(isLoading: false, value: .none)
    
    init(id: UUID = UUID()) {
      self.id = id
    }
  }
  
  enum Action: BindableAction, Sendable {
    case binding(BindingAction<State>)
    case search(String)
    case fetchSearchItem(Result<GithubEntity.Search.Topic.Response, CompositeErrorRepository>)
    
    case throwError(CompositeErrorRepository)
    case teardown
  }
  
  enum CancelID: Equatable, CaseIterable {
    case teardown
    case requestSearch
  }
  
  var body: some Reducer<State, Action> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
      case .search(let query):
        state.fetchSearchItem.isLoading = true
        let page = Int(state.itemList.count / 30) + 1
        
        return sideEffect.searchTopic(.init(query: query, page: page))
        
      case .fetchSearchItem(let result):
        state.fetchSearchItem.isLoading = false
        
        switch result {
        case .success(let item):
          state.fetchSearchItem.value = item
          let mergedItemList = state.itemList.merge(item.itemList)
          state.itemList = mergedItemList
          state.itemList = mergedItemList.filter { $0.displayName != nil }
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
  private let sideEffect: TopicSideEffect
}

extension [GithubEntity.Search.Topic.Item] {
  fileprivate func merge(_ target: Self) -> Self {
    let new = target.reduce(self) { curr, next in
      guard !self.contains(where: { $0.displayName == next.displayName })
      else { return curr }
      return curr + [next]
    }
    
    return new
  }
}
