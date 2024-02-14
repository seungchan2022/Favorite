import Architecture
import ComposableArchitecture
import SwiftUI
import DesignSystem

// MARK: - UserPage

struct UserPage {
  @Bindable var store: StoreOf<UserStore>
}

extension UserPage {
  private var searchViewState: SearchBar.ViewState {
    .init(text: $store.query)
  }
}

// MARK: View

extension UserPage: View {
  var body: some View {
    NavigationStack {
      VStack {
        SearchBar(
          viewState: .init(text: $store.query),
          throttleAction: {
            print("AAA ", store.query)
            store.send(.search(store.query))
          })
      }
      
      ScrollView {
        LazyVStack {
          ForEach(store.itemList, id: \.id) { item in
            UserItemComponent(
              viewState: .init(item: item),
              action: { _ in print(item) })
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
    .navigationTitle("User")
    .onAppear {
      store.send(.search(store.query))
    }
  }
}
