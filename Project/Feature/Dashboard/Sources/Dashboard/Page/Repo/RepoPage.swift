import ComposableArchitecture
import SwiftUI
import DesignSystem

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
          ForEach(store.itemList, id: \.id) {
            RepositoryItemComponent(
              viewState: .init(item: $0),
              action: { print($0) })
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
