import Architecture
import ComposableArchitecture
import Domain
import Foundation

@Reducer
public struct UserDetailReducer {

  // MARK: Lifecycle

  public init(
    pageID: String = UUID().uuidString,
    sideEffect: UserDetailSideEffect)
  {
    self.pageID = pageID
    self.sideEffect = sideEffect
  }

  // MARK: Public

  @ObservableState
  public struct State: Equatable, Identifiable {
    public let id: UUID
    public var item: GithubEntity.Detail.User.Request
    public var fetchDetailItem: FetchState.Data<GithubEntity.Detail.User.Response?> = .init(isLoading: false, value: .none)
    public var fetchIsLike: FetchState.Data<Bool> = .init(isLoading: false, value: false)

    public init(
      id: UUID = UUID(),
      item: GithubEntity.Detail.User.Request)
    {
      self.id = id
      self.item = item
    }
  }

  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)

    case teardown

    case getDetail(GithubEntity.Detail.User.Request)

    case getIsLike(GithubEntity.Detail.User.Response?)
    case updateIsLike(GithubEntity.Detail.User.Response)

    case fetchDetailItem(Result<GithubEntity.Detail.User.Response, CompositeErrorRepository>)
    case fetchIsLike(Result<Bool, CompositeErrorRepository>)

    case rouetToProfile(GithubEntity.Detail.User.Response)
    case routeToFollower(GithubEntity.Detail.User.Response)

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

      case .getDetail(let requestModel):
        state.fetchDetailItem.isLoading = true
        return sideEffect.user(requestModel)
          .cancellable(pageID: pageID, id: CancelID.requestDetail, cancelInFlight: true)

      case .getIsLike(let item):
        guard let item else { return .none }
        state.fetchIsLike.isLoading = true
        return sideEffect.isLike(item)
          .cancellable(pageID: pageID, id: CancelID.requestIsLike, cancelInFlight: true)

      case .updateIsLike(let item):
        state.fetchIsLike.isLoading = true
        return sideEffect.updateIsLike(item)
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

      case .rouetToProfile(let item):
        sideEffect.rouetToProfile(item)
        return .none

      case .routeToFollower(let item):
        sideEffect.routeToFollower(item)
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
  private let sideEffect: UserDetailSideEffect
}
