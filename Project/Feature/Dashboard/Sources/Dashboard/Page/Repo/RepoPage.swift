import ComposableArchitecture
import DesignSystem
import SwiftUI

// MARK: - RepoPage

struct RepoPage {
  @Bindable var store: StoreOf<RepoStore>
}

extension RepoPage {
  private var searchViewState: SearchBar.ViewState {
    .init(text: $store.query)
  }
}

// MARK: View

extension RepoPage: View {
  var body: some View {
    NavigationStack {
      VStack {
        SearchBar(
          viewState: searchViewState,
          throttleAction: {
            store.send(.search(store.query))
          })
      }

      ScrollView {
        LazyVStack(spacing: .zero) {
          ForEach(store.itemList, id: \.id) { item in
            RepositoryItemComponent(
              viewState: .init(item: item),
              action: { _ in })
              .onAppear {
                guard let last = store.itemList.last, last.id == item.id else { return }
                guard !store.fetchSearchItem.isLoading else { return }
                store.send(.search(store.query))
              }
          }
        }
      }
      .scrollDismissesKeyboard(.immediately)
    }
    .navigationTitle("Repository")
    .onAppear {
      store.send(.search(store.query))
    }
  }
}
