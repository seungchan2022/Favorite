import ComposableArchitecture
import SwiftUI

// MARK: - RepoPage

struct RepoPage {
  @Bindable var store: StoreOf<RepoStore>
}

// MARK: View

extension RepoPage: View {
  var body: some View {
    NavigationStack {
      Text("RepoPage")
    }
    .searchable(text: $store.query)
    .navigationTitle("Repository")
    .onAppear {
      store.send(.search(store.query))
    }
  }
}
