import Architecture
import ComposableArchitecture
import Domain
import SwiftUI

// MARK: - ProfilePage

struct ProfilePage {
  @Bindable var store: Store<ProfileStore.State, ProfileStore.Action>
}

// MARK: View

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
