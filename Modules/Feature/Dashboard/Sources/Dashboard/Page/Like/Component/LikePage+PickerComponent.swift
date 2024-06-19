import DesignSystem
import Domain
import SwiftUI
import ComposableArchitecture

extension LikePage {
  struct PickerComponent {
    let viewState: ViewState
    
    @Bindable var store: StoreOf<LikeReducer>
  }
}

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

extension LikePage.PickerComponent {
  struct ViewState: Equatable { }
}
