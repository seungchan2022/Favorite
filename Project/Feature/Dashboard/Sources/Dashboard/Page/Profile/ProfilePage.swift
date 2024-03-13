import ComposableArchitecture
import SwiftUI

// MARK: - ProfilePage

struct ProfilePage {
  @Bindable var store: StoreOf<ProfileReducer>
}

extension ProfilePage {
  private var navigationTitle: String {
    store.item.name ?? ""
  }

  private var shareURL: URL? {
    guard let str = store.item.htmlURL else { return .none }
    return .init(string: str)
  }
}

// MARK: View

extension ProfilePage: View {
  var body: some View {
    VStack {
      WebContent(viewState: .init(item: store.item))
    }
    .navigationTitle(navigationTitle)
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      if let shareURL {
        ToolbarItem(placement: .topBarTrailing) {
          ShareLink(item: shareURL) {
            Image(systemName: "square.and.arrow.up")
          }
        }
      }
    }
  }
}
