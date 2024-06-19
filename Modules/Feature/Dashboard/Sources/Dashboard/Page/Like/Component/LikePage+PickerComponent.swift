import ComposableArchitecture
import DesignSystem
import Domain
import SwiftUI

// MARK: - LikePage.PickerComponent

extension LikePage {
  struct PickerComponent {
    let viewState: ViewState

    @Bindable var store: StoreOf<LikeReducer>
  }
}

// MARK: - LikePage.PickerComponent + View

extension LikePage.PickerComponent: View {
  var body: some View {
    Picker("", selection: $store.state.selectedLikeList) {
      Text(LikeList.repoList.rawValue)
        .tag(LikeList.repoList)

      Text(LikeList.userList.rawValue)
        .tag(LikeList.userList)
    }
    .pickerStyle(.segmented)
    .padding(.horizontal, 12)
  }
}

// MARK: - LikePage.PickerComponent.ViewState

extension LikePage.PickerComponent {
  struct ViewState: Equatable { }
}
