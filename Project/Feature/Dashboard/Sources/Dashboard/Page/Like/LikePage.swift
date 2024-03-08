import ComposableArchitecture
import SwiftUI

// MARK: - LikePage

struct LikePage {
  @Bindable var store: StoreOf<LikeReducer>
}

// MARK: View

extension LikePage: View {
  var body: some View {
    VStack {
      Text("LikePage")
      
      ForEach(store.itemList.repoList, id: \.id) { item in
        Text(item.fullName)
      }
      
      ForEach(store.itemList.userList, id: \.loginName) { item in
        Text(item.loginName)
      }
    }
    .onAppear {
      store.send(.getItemList)
    }
    .onDisappear {
      store.send(.teardown)
    }
  }
}
