import Architecture
import ComposableArchitecture
import DesignSystem
import SwiftUI

// MARK: - LikePage

struct LikePage {
  @Bindable var store: StoreOf<LikeReducer>
}

extension LikePage {
  private var emptyItemMessage: String {
    "좋아요를 누른 아이템이 없습니다."
  }

  private var isLoading: Bool {
    store.fetchItemList.isLoading
  }

  private var navigationTitle: String {
    "Like"
  }

  private var tabNavigationComponentViewState: TabNavigationComponent.ViewState {
    .init(activeMatchPath: Link.Like.Path.like.rawValue)
  }
}

// MARK: View

extension LikePage: View {
  var body: some View {
    VStack {
      DesignSystemNavigation(
        barItem: .init(title: ""),
        largeTitle: "Like")
      {
        PickerComponent(viewState: .init(), store: store)

        switch store.state.selectedLikeList {
        case .repoList:
          if store.itemList.repoList.isEmpty {
            Text(emptyItemMessage)
              .padding(16)
          }

          LazyVStack(spacing: .zero) {
            ForEach(store.itemList.repoList, id: \.id) { item in
              RepoItemComponent(
                viewState: .init(item: item),
                action: { store.send(.routeToRepoDetail($0)) })

              Divider()
            }
          }

        case .userList:
          LazyVStack(spacing: .zero) {
            if store.itemList.userList.isEmpty {
              Text(emptyItemMessage)
                .padding(16)
            }

            ForEach(store.itemList.userList, id: \.loginName) { item in
              UserItemComponent(
                viewState: .init(item: item),
                action: { store.send(.routeToUserDetail($0)) })

              Divider()
            }
          }
        }
      }

      TabNavigationComponent(
        viewState: tabNavigationComponentViewState,
        tapAction: { store.send(.routeToTabBarItem($0)) })
    }

    .ignoresSafeArea(.all, edges: .bottom)
    .toolbar(.hidden, for: .navigationBar)
    .setRequestFlightView(isLoading: isLoading)
    .onAppear {
      store.send(.getItemList)
    }
    .onDisappear {
      store.send(.teardown)
    }
  }
}
