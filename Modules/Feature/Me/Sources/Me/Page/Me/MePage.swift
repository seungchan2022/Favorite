import Architecture
import ComposableArchitecture
import DesignSystem
import SwiftUI

struct MePage {
  @Bindable var store: StoreOf<MeReducer>
}

extension MePage {
  private var tabNavigationComponentViewState: TabNavigationComponent.ViewState {
    .init(activeMatchPath: Link.Me.Path.me.rawValue)
  }
}

extension MePage: View {
  var body: some View {
    VStack {
      DesignSystemNavigation(
        barItem: .init(title: ""),
        largeTitle: "Me") {
          
          VStack {
            Text("프로필 정보 표현")
          }
          .padding(16)
          

        }
      
      TabNavigationComponent(
        viewState: tabNavigationComponentViewState,
        tapAction: { store.send(.routeToTabBarItem($0)) })
    }
    .ignoresSafeArea(.all, edges: .bottom)
    .toolbar(.hidden, for: .navigationBar)
  }
}
