import Architecture
import ComposableArchitecture
import Dispatch
import Domain
import Foundation

@Reducer
public struct RepoDetailReducer {

  // MARK: Lifecycle

  public init(
    pageID: String = UUID().uuidString,
    sideEffect: RepoDetailSideEffect)
  {
    self.pageID = pageID
    self.sideEffect = sideEffect
  }

  // MARK: Public

  @ObservableState
  public struct State: Equatable, Identifiable {
    public let id: UUID
    public let item: GithubEntity.Detail.Repository.Request
    public var fetchDetailItem: FetchState.Data<GithubEntity.Detail.Repository.Response?> = .init(isLoading: false, value: .none)

    public var fetchIsLike: FetchState.Data<Bool> = .init(isLoading: false, value: false)

    public init(
      id: UUID = UUID(),
      item: GithubEntity.Detail.Repository.Request)
    {
      self.id = id
      self.item = item
    }
  }

  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case teardown

    case getDetail

    /// - Note: 불러온 Respone의 아이템이 좋아요 상태를 불러옴 (Like OR UnLike)
    case getIsLike(GithubEntity.Detail.Repository.Response)

    /// - Note: 좋아요에 대한 토글 액션 (버튼을 누르면 Like <-> UnLike)
    case updateIsLike(GithubEntity.Detail.Repository.Response)

    case fetchDetailItem(Result<GithubEntity.Detail.Repository.Response, CompositeErrorRepository>)

    case fetchIsLike(Result<Bool, CompositeErrorRepository>)
    
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

      case .getDetail:
        state.fetchDetailItem.isLoading = true
        return sideEffect
          .detail(state.item)
          .cancellable(pageID: pageID, id: CancelID.requestDetail, cancelInFlight: true)

      case .getIsLike(let item):
        state.fetchIsLike.isLoading = true
        return sideEffect
          .isLike(item)
          .cancellable(pageID: pageID, id: CancelID.requestIsLike, cancelInFlight: true)

      case .updateIsLike(let item):
        state.fetchIsLike.isLoading = true
        return sideEffect
          .updateIsLike(item)
          .cancellable(pageID: pageID, id: CancelID.requestIsLike, cancelInFlight: true)

      case .fetchDetailItem(let result):
        state.fetchDetailItem.isLoading = false
        switch result {
        case .success(let item):
          state.fetchDetailItem.value = item
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
    case requestDetail
    case requestIsLike
  }

  // MARK: Private

  private let pageID: String
  private let sideEffect: RepoDetailSideEffect
}
