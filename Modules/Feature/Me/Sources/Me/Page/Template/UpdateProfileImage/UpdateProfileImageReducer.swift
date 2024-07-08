import _PhotosUI_SwiftUI
import Architecture
import ComposableArchitecture
import Domain
import Foundation

@Reducer
struct UpdateProfileImageReducer {

  // MARK: Lifecycle

  init(
    pageID: String = UUID().uuidString,
    sideEffect: UpdateProfileImageSideEffect)
  {
    self.pageID = pageID
    self.sideEffect = sideEffect
  }

  // MARK: Internal

  @ObservableState
  struct State: Equatable, Identifiable {
    let id: UUID

    var isShowPhotoPicker = false
    var selectedImage: PhotosPickerItem?

    var item: Auth.Me.Response = .init(uid: "", userName: "", email: "", photoURL: "")

    var fetchUserInfo: FetchState.Data<Auth.Me.Response?> = .init(isLoading: false, value: .none)
    var fetchUpdateProfileImage: FetchState.Data<Bool> = .init(isLoading: false, value: false)

    init(id: UUID = UUID()) {
      self.id = id
    }
  }

  enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case teardown

    case getUserInfo

    case updateProfileImage(Data)

    case fetchUserInfo(Result<Auth.Me.Response?, CompositeErrorRepository>)
    case fetchUpdateProfileImage(Result<Bool, CompositeErrorRepository>)

    case routeToBack

    case throwError(CompositeErrorRepository)
  }

  enum CancelID: Equatable, CaseIterable {
    case teardown
    case requestUserInfo
    case requestUpdateProfileImage
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

      case .getUserInfo:
        state.fetchUserInfo.isLoading = true
        return sideEffect
          .userInfo()
          .cancellable(pageID: pageID, id: CancelID.requestUserInfo, cancelInFlight: true)

      case .updateProfileImage(let imageData):
        state.fetchUpdateProfileImage.isLoading = true
        return sideEffect
          .updateProfileImage(imageData)
          .cancellable(pageID: pageID, id: CancelID.requestUpdateProfileImage, cancelInFlight: true)

      case .fetchUserInfo(let result):
        state.fetchUserInfo.isLoading = false
        switch result {
        case .success(let item):
          state.item = item ?? .init(uid: "", userName: "", email: "", photoURL: "")
          return .none

        case .failure(let error):
          return .run { await $0(.throwError(error)) }
        }

      case .fetchUpdateProfileImage(let result):
        state.fetchUpdateProfileImage.isLoading = false
        switch result {
        case .success:
          sideEffect.routeToBack()
          sideEffect.useCase.toastViewModel.send(message: "프로필 이미지가 변경되었습니다.")
          return .none

        case .failure(let error):
          return .run { await $0(.throwError(error)) }
        }

      case .routeToBack:
        sideEffect.routeToBack()
        return .none

      case .throwError(let error):
        return .run { await $0(.throwError(error)) }
      }
    }
  }

  // MARK: Private

  private let pageID: String
  private let sideEffect: UpdateProfileImageSideEffect
}
