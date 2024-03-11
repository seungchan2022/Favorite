import ComposableArchitecture
import SwiftUI

// MARK: - UserDetailPage

struct UserDetailPage {
  @Bindable var store: Store<UserDetailReducer.State, UserDetailReducer.Action>
}

extension UserDetailPage {
  var shareURL: URL? {
    guard let str = store.fetchDetailItem.value?.htmlURL else { return .none }
    return .init(string: str)
  }

  var navigationTitle: String {
    store.fetchDetailItem.value?.name ?? ""
  }
}

// MARK: View

extension UserDetailPage: View {
  var body: some View {
    VStack {
      if let item = store.fetchDetailItem.value {
        ItemComponent(viewState: .init(item: item))
      }
    }
    .navigationTitle(navigationTitle)
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      if let detailItem = store.fetchDetailItem.value {
        ToolbarItem(placement: .topBarTrailing) {
          LikeComponent(
            viewState: .init(
              isLike: store.fetchIsLike.value,
              item: detailItem),
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
    .onChange(of: store.fetchDetailItem.value) { _, new in
      store.send(.getIsLike(new))
    }
    .onAppear {
      store.send(.getDetail(store.item))
    }
    .onDisappear {
      store.send(.teardown)
    }
  }
}
