import ComposableArchitecture
import SwiftUI

// MARK: - TopicPage

struct TopicPage {
  @Bindable var store: StoreOf<TopicStore>
}

// MARK: View

extension TopicPage: View {
  var body: some View {
    ScrollView {
      LazyVStack {
        ForEach(store.itemList, id: \.name) { item in
          TopicItemComponent(viewState: .init(item: item))
        }
      }
      
    }
    .navigationTitle("Topic")
    .searchable(text: $store.query)
    .onAppear {
      store.send(.search(store.query))
    }
  }
}
