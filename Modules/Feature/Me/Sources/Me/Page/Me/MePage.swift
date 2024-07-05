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

  private var userName: String {
    guard let userName = store.item.userName else { return "" }
    return userName.isEmpty ? "이름을 설정해주세요." : userName
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
          VStack(alignment: .leading) {
            HStack(spacing: 12) {
              RemoteImage(url: store.item.photoURL ?? "") {
                Image(systemName: "person.circle")
                  .resizable()
                  .frame(width: 80, height: 80)
                  .fontWeight(.ultraLight)
              }
              .scaledToFill()
              .frame(width: 80, height: 80)
              .clipShape(Circle())

              VStack(alignment: .leading) {
                Text("이메일: \(store.item.email ?? "")")

                Text("이름: \(userName)")
              }

              Spacer()

              Image(systemName: "chevron.right")
                .resizable()
                .foregroundStyle(.black)
                .frame(width: 14, height: 20)
            }
            .padding(.horizontal, 16)

            Divider()
          }

          .frame(maxWidth: .infinity, alignment: .leading)
          .onTapGesture { }

          VStack(spacing: 32) {
            Button(action: { }) {
              VStack {
                HStack {
                  Image(systemName: "lock.square")
                    .resizable()
                    .foregroundStyle(.black)
                    .frame(width: 20, height: 20)

                  Text("로그인 / 보안")
                    .font(.headline)
                    .foregroundStyle(.black)

                  Spacer()

                  Image(systemName: "chevron.right")
                    .resizable()
                    .fontWeight(.light)
                    .foregroundStyle(.black)
                    .frame(width: 14, height: 20)
                }
                Divider()
              }
            }
            .padding(.horizontal, 16)
          }
          .padding(.top, 32)
        }

        Button(action: { store.send(.onTapUpdateUserName) }) {
          Text("2yhh")
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
