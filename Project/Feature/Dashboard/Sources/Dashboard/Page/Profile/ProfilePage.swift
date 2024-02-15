import SwiftUI
import ComposableArchitecture

struct ProfilePage {
  @Bindable var store: StoreOf<ProfileStore>
}

extension ProfilePage: View {
  var body: some View {
    Text("ProfilePage")
  }
}
