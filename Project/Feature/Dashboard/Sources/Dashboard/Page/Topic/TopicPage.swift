import ComposableArchitecture
import SwiftUI
import Functor

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
        }
      }
    }
    .navigationTitle("Topic")
    .searchable(text: $store.query)
    .onChange(of: store.query, { _, new in
      throttleEvent.update(value: store.query)
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
