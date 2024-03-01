import ComposableArchitecture
import SwiftUI

// MARK: - TopicDetailPage

struct TopicDetailPage {
  @Bindable var store: StoreOf<TopicDetailStore>
}

// MARK: View

extension TopicDetailPage: View {
  var body: some View {
    Text("Topic Detail Page")
  }
}
