import ComposableArchitecture
import DesignSystem
import SwiftUI

// MARK: - UpdateAuthPage

struct UpdateAuthPage {
  @Bindable var store: StoreOf<UpdateAuthReducer>
}

extension UpdateAuthPage {

  private var isLoading: Bool {
    store.fetchUserInfo.isLoading
      || store.fetchUpdateUserName.isLoading
  }

  private var userName: String {
    guard let userName = store.item.userName else { return "" }
    return userName.isEmpty ? "이름을 설정해주세요." : userName
  }
}

// MARK: View

extension UpdateAuthPage: View {
  var body: some View {
    VStack {
      DesignSystemNavigation(
        barItem: .init(
          backAction: .init(
            image: Image(systemName: "chevron.left"),
            action: { store.send(.routeToBack) }),
          title: "로그인/보안",
          moreActionList: []),
        isShowDivider: true)
      {
        VStack(spacing: 16) {
          HStack {
            VStack(alignment: .leading, spacing: 16) {
              Text("이메일")

              Text(store.item.email ?? "")
            }

            Spacer()
          }
          .padding(.horizontal, 16)

          Divider()

          HStack {
            VStack(alignment: .leading, spacing: 16) {
              Text("이름")
              Text(userName)
            }

            Spacer()

            Button(action: { store.send(.onTapUpdateUserName) }) {
              Text("변경")
            }
          }
          .padding(.horizontal, 16)

          Divider()

          HStack {
            VStack(alignment: .leading, spacing: 16) {
              Text("비밀번호")
              Text("************")
            }

            Spacer()

            Button(action: { }) {
              Text("변경")
            }
          }
          .padding(.horizontal, 16)

          Divider()
        }
      }
    }
    .overlay(alignment: .bottom) {
      Button(action: { }) {
        Text("계정 탈퇴")
      }
      .padding(.bottom, 64)
      .padding(.top, 32)
    }
    .toolbar(.hidden, for: .navigationBar)
    .setRequestFlightView(isLoading: isLoading)
    .onAppear {
      store.send(.getUserInfo)
    }
    .onDisappear {
      store.send(.teardown)
    }
  }
}
