import ComposableArchitecture
import DesignSystem
import Functor
import SwiftUI

// MARK: - TopicPage

struct TopicPage {
  @Bindable var store: StoreOf<TopicStore>
  @State private var throttleEvent: ThrottleEvent = .init(value: "", delaySeconds: 1.5)
}

// MARK: View

extension TopicPage: View {
  var body: some View {
    ScrollView {
      LazyVStack(spacing: .zero) {
        ForEach(store.itemList, id: \.name) { item in
          TopicItemComponent(
            viewState: .init(item: item),
            action: { _ in store.send(.routeToDetail) })
            .onAppear {
              guard let last = store.itemList.last, last.name == item.name else { return }
              guard !store.fetchSearchItem.isLoading else { return }
              store.send(.search(store.query))
            }
        }
      }
    }
    .navigationTitle("Topic")
    .searchable(text: $store.query)
    .onChange(of: store.query) { _, new in
      throttleEvent.update(value: new)
    }
    .onAppear {
      throttleEvent.apply { _ in
        store.send(.search(store.query))
      }
    }
    .onDisappear {
      throttleEvent.reset()
      store.send(.teardown)
    }
  }
}
