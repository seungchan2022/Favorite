import Architecture
import ComposableArchitecture
import Domain
import SwiftUI

// MARK: - UserDetailPage

struct UserDetailPage {
  @Bindable var store: Store<UserDetailStore.State, UserDetailStore.Action>
}

// MARK: View

extension UserDetailPage: View {
  var body: some View {
    ScrollView {
      VStack {
        if let UserDetailItem = store.UserDetailItem {
          ItemComponent(viewState: .init(item: UserDetailItem))
        } else {
          Text("Loading...")
        }
      }
    }
    .onAppear {
      store.send(.getUserDetailItem(store.name))
    }
  }
}
