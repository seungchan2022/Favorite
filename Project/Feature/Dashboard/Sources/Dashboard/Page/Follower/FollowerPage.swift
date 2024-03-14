import ComposableArchitecture
import SwiftUI

// MARK: - FollowerPage

struct FollowerPage {
  @Bindable var store: StoreOf<FollowerReducer>
}

extension FollowerPage {
  private var gridColumnList: [GridItem] {
    Array(
      repeating: .init(.flexible()),
      count: UIDevice.current.userInterfaceIdiom == .pad ? 6 : 3)
  }
}

// MARK: View

extension FollowerPage: View {
  var body: some View {
    ScrollView {
      LazyVGrid(columns: gridColumnList, spacing: .zero) {
        ForEach(store.itemList) { item in
          ItemComponent(
            viewState: .init(item: item),
            action: { store.send(.routeToUser($0)) })
        }
      }
    }
    .navigationTitle("Follower")
    .navigationBarTitleDisplayMode(.inline)
    .onAppear {
      store.send(.getItem(store.item))
    }
    .onDisappear {
      store.send(.teardown)
    }
  }
}
