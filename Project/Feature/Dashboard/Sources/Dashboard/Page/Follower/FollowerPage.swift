import SwiftUI
import ComposableArchitecture

struct FollowerPage {
  @Bindable var store: StoreOf<FollowerReducer>
}

extension FollowerPage: View {
  var body: some View {
    Text("FollowerPage")
  }
}
