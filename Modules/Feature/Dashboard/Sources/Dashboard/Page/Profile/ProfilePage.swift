import ComposableArchitecture
import SwiftUI

// MARK: - ProfilePage

struct ProfilePage {
  @Bindable var store: StoreOf<ProfileReducer>
}

extension ProfilePage {
  private var navigationTitle: String {
    store.fetchItem.value?.loginName ?? ""
  }

  private var shareURL: URL? {
    guard let str = store.fetchItem.value?.htmlURL else { return .none }

    return .init(string: str)
  }
}

// MARK: View

extension ProfilePage: View {
  var body: some View {
    VStack {
      if let item = store.fetchItem.value {
        WebContent(viewState: .init(item: item))
      } else {
        Text("로딩중...")
      }
    }
    .navigationTitle(navigationTitle)
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      if let item = store.fetchItem.value {
        ToolbarItem(placement: .topBarTrailing) {
          LikeComponent(
            viewState: .init(
              isLike: store.fetchIsLike.value,
              item: item),
            likeAction: { store.send(.updateIsLike($0)) })
        }
      }

      if let shareURL {
        ToolbarItem(placement: .topBarTrailing) {
          ShareLink(item: shareURL) {
            Image(systemName: "square.and.arrow.up")
          }
        }
      }
    }
    .onChange(of: store.fetchItem.value) { _, new in
      store.send(.getIsLike(new))
    }
    .onAppear {
      store.send(.getItem)
    }
    .onDisappear {
      store.send(.teardown)
    }
  }
}
