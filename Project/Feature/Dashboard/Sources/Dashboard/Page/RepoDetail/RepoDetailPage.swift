import ComposableArchitecture
import SwiftUI
import Domain

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
}

// MARK: View

extension RepoDetailPage: View {
  var body: some View {
    VStack {
      if let item = store.fetchDetailItem.value {
        WebContent(viewState: .init(item: item))

      } else {
        Text("로딩중...")
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
      store.send(.getIsLike(new))
    }
    .onAppear {
      store.send(.getDetail)
    }
    .onDisappear {
      store.send(.teardown)
    }
  }
}
