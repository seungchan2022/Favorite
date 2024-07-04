import Architecture
import ComposableArchitecture
import DesignSystem
import SwiftUI

// MARK: - MePage

struct MePage {
  @Bindable var store: StoreOf<MeReducer>
}

extension MePage {
  private var tabNavigationComponentViewState: TabNavigationComponent.ViewState {
    .init(activeMatchPath: Link.Me.Path.me.rawValue)
  }
  
  private var isLoading: Bool {
    store.fetchUserInfo.isLoading
    || store.fetchSignOut.isLoading
    || store.fetchUpdateUserName.isLoading
  }
}

// MARK: View

extension MePage: View {
  var body: some View {
    VStack {
      DesignSystemNavigation(
        barItem: .init(title: ""),
        largeTitle: "Me")
      {
        VStack {
          Text("프로필 정보 표현")
          
          Text("Uid: \(store.state.item.uid)")
          Text("UserName: \(store.state.item.userName ?? "")")
          Text("Email: \(store.state.item.email ?? "")")
          Text("PhotoURL: \(store.state.item.photoURL ?? "")")
          
          Button(action: { store.send(.onTapSignOut) }) {
            Text("로그아웃")
          }
          
          Button(action: { store.send(.onTapUpdateUserName) }) {
            Text("변경")
          }
        }
        .padding(16)
      }

      TabNavigationComponent(
        viewState: tabNavigationComponentViewState,
        tapAction: { store.send(.routeToTabBarItem($0)) })
    }
    .ignoresSafeArea(.all, edges: .bottom)
    .toolbar(.hidden, for: .navigationBar)
    .setRequestFlightView(isLoading: isLoading)
    .onAppear {
      store.send(.getUserInfo)
    }
  }
}
