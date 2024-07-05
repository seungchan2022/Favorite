import ComposableArchitecture
import DesignSystem
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
    VStack {
      DesignSystemNavigation(
        barItem: .init(
          backAction: .init(
            image: Image(systemName: "chevron.left"),
            action: { store.send(.routeToBack) }),
          title: navigationTitle,
          moreActionList: [
            .init(image: Image(systemName: "house"), action: { store.send(.routeToHome) }),
          ]),
        isShowDivider: true)
      {
        if store.itemList.isEmpty {
          Text("팔로워가 없습니다.")
        }

        LazyVGrid(columns: gridColumnList, spacing: .zero) {
          ForEach(store.itemList) { item in
            ItemComponent(
              viewState: .init(item: item),
              action: { store.send(.routeToUser($0)) })
          }
        }
      }
    }
    .toolbar(.hidden, for: .navigationBar)
    .setRequestFlightView(isLoading: isLoading)
    .onAppear {
      store.send(.getItem(store.item))
    }
    .onDisappear {
      store.send(.teardown)
    }
  }
}
