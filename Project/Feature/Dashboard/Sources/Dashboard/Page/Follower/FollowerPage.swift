import SwiftUI
import ComposableArchitecture

struct FollowerPage {
  @Bindable var store: StoreOf<FollowerReducer>
}

extension FollowerPage: View {
  var body: some View {
    ScrollView {
      VStack {
        ForEach(store.itemList) { item in
          Text(item.login)
        }
        
        Text("\(store.itemList.count)")
      }
    }
    .onAppear {
      store.send(.getItem(store.item))
      print(store.itemList)
    }
    .onDisappear {
      store.send(.teardown)
    }
  }
}
