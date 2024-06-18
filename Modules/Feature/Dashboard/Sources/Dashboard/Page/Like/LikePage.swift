import ComposableArchitecture
import SwiftUI
import DesignSystem

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
}

// MARK: View

extension LikePage: View {
  var body: some View {
    ScrollView {
      VStack {
        Picker("", selection: $store.state.selectedLikeList) {
          Text(LikeList.repoList.rawValue)
            .tag(LikeList.repoList)

          Text(LikeList.userList.rawValue)
            .tag(LikeList.userList)
        }
        .pickerStyle(.segmented)
        .padding(.horizontal, 12)

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
    }
    .navigationTitle("Like")
    .setRequestFlightView(isLoading: isLoading)
    .onAppear {
      store.send(.getItemList)
    }
    .onDisappear {
      store.send(.teardown)
    }
  }
}
