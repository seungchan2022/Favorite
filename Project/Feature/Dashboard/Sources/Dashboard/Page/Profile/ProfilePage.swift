import SwiftUI
import ComposableArchitecture
import Domain
import Architecture

struct ProfilePage {
  @Bindable var store: Store<ProfileStore.State, ProfileStore.Action>
}

extension ProfilePage: View {
  var body: some View {
    ScrollView {
      VStack {
        if let profileItem = store.profileItem {
          ItemComponent(viewState: .init(item: profileItem))
        } else {
          Text("Loading...")
        }
      }
    }
    .onAppear {
      store.send(.getProfileItem(store.name))
    }
  }
}
