import ComposableArchitecture
import DesignSystem
import SwiftUI

// MARK: - UserDetailPage

struct UserDetailPage {
  
  @Bindable var store: StoreOf<UserDetailReducer>
}

extension UserDetailPage {
  
  // MARK: Internal
  
  var shareURL: URL? {
    guard let str = store.fetchDetailItem.value?.htmlURL else { return .none }
    return .init(string: str)
  }
  
  var navigationTitle: String {
    store.fetchDetailItem.value?.name ?? ""
  }
  
  // MARK: Private
  
  private var isLoding: Bool {
    store.fetchIsLike.isLoading
    || store.fetchDetailItem.isLoading
  }
}

// MARK: View

extension UserDetailPage: View {
  var body: some View {
    VStack {
      if let item = store.fetchDetailItem.value {
        ItemComponent(
          viewState: .init(item: item),
          profileAction: { store.send(.routeToProfile($0)) },
          followerAction: { store.send(.routeToFollower($0)) })
      }
    }
    .toolbar(.visible, for: .navigationBar)
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
      guard let new else { return }
      store.send(.getIsLike(new))
    }
    .setRequestFlightView(isLoading: isLoding)
    .onAppear {
      store.send(.getDetail(store.item))
    }
    .onDisappear {
      store.send(.teardown)
    }
  }
}
