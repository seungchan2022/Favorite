import ComposableArchitecture
import SwiftUI
import DesignSystem

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
  
  private var isLoading: Bool {
    store.fetchItem.isLoading
  }
  
  private var navigationTitle: String {
    "Follower"
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
    .navigationTitle(navigationTitle)
    .navigationBarTitleDisplayMode(.inline)
    .setRequestFlightView(isLoading: isLoading)
    .onAppear {
      store.send(.getItem(store.item))
    }
    .onDisappear {
      store.send(.teardown)
    }
  }
}
