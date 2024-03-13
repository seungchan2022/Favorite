import ComposableArchitecture
import SwiftUI

// MARK: - FollowerPage

struct FollowerPage {
  @Bindable var store: StoreOf<FollowerReducer>
}

// MARK: View

extension FollowerPage: View {
  var body: some View {
    ScrollView {
      VStack {
        ForEach(store.itemList) { item in
          ItemComponent(viewState: .init(item: item))
        }
      }
    }
    .onAppear {
      store.send(.getItem(store.item))
    }
    .onDisappear {
      store.send(.teardown)
    }
  }
}
