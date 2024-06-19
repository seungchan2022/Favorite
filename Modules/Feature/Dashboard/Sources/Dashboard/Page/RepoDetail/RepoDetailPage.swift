import ComposableArchitecture
import Domain
import SwiftUI
import DesignSystem

// MARK: - RepoDetailPage

struct RepoDetailPage {
  @Bindable var store: StoreOf<RepoDetailReducer>
}

extension RepoDetailPage {
  var shareURL: URL? {
    guard let str = store.fetchDetailItem.value?.htmlURL else { return .none }
    return .init(string: str)
  }

  var navigationtitle: String {
    store.fetchDetailItem.value?.fullName ?? ""
  }
  
  private var isLoading: Bool {
    store.fetchIsLike.isLoading
    || store.fetchDetailItem.isLoading
  }
}

// MARK: View

extension RepoDetailPage: View {
  var body: some View {
    VStack {
      if let item = store.fetchDetailItem.value {
        WebContent(viewState: .init(item: item))
      }
    }
    .navigationTitle(navigationtitle)
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
    .setRequestFlightView(isLoading: isLoading)
    .onAppear {
      store.send(.getDetail)
    }
    .onDisappear {
      store.send(.teardown)
    }
  }
}
