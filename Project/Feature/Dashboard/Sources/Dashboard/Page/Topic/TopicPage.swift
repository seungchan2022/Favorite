import ComposableArchitecture
import SwiftUI

struct TopicPage {
  @Bindable var store: StoreOf<TopicStore>
}

extension TopicPage: View {
  var body: some View {
    Text("Topic page")
  }
}
