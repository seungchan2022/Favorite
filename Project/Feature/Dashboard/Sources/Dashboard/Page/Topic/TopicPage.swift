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
      VStack {
        Text("topic page")
      }
    }
    .navigationTitle("Topic")
    .searchable(text: $store.query)
    .onAppear {
      store.send(.search(store.query))
    }
  }
}
