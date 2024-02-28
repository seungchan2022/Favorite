import ComposableArchitecture
import SwiftUI
import Functor
import DesignSystem

// MARK: - TopicPage

struct TopicPage {
  @Bindable var store: StoreOf<TopicStore>
  @State private var throttleEvent: ThrottleEvent = .init(value: "", delaySeconds: 1.5)
}

// MARK: View

extension TopicPage: View {
  var body: some View {
    ScrollView {
      LazyVStack {
        ForEach(store.itemList, id: \.name) { item in
          TopicItemComponent(viewState: .init(item: item))
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
    .onChange(of: store.query, { _, new in
      throttleEvent.update(value: new)
    })
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
