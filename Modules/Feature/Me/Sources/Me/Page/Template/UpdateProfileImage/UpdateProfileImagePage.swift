import ComposableArchitecture
import DesignSystem
import PhotosUI
import SwiftUI

// MARK: - UpdateProfileImagePage

struct UpdateProfileImagePage {
  @Bindable var store: StoreOf<UpdateProfileImageReducer>

}

extension UpdateProfileImagePage {
  private var userName: String {
    guard let userName = store.item.userName else { return "이름을 설정해주세요." }
    return userName.isEmpty ? "이름을 설정해주세요." : userName
  }

  private var isLoading: Bool {
    store.fetchUserInfo.isLoading
      || store.fetchUpdateProfileImage.isLoading
  }
}

// MARK: View

extension UpdateProfileImagePage: View {
  var body: some View {
    VStack {
      DesignSystemNavigation(
        barItem: .init(
          backAction: .init(
            image: Image(systemName: "chevron.left"),
            action: { store.send(.routeToBack) }),
          title: "프로필",
          moreActionList: []),
        isShowDivider: true)
      {
        VStack(spacing: 32) {
          RemoteImage(url: store.item.photoURL ?? "") {
            Image(systemName: "person.circle")
              .resizable()
              .frame(width: 150, height: 150)
              .fontWeight(.ultraLight)
          }
          .scaledToFill()
          .frame(width: 150, height: 150)
          .clipShape(Circle())
          .onTapGesture {
            store.isShowPhotoPicker = true
          }

          Text("이메일: \(store.item.email ?? "")")

          Text("이름: \(userName)")

          Divider()
        }
      }
    }
    .photosPicker(
      isPresented: $store.isShowPhotoPicker ,
      selection: $store.selectedImage)
    .onChange(of: store.selectedImage) { _, new in
      Task {
        guard let item = new else { return }
        guard let data = try? await item.loadTransferable(type: Data.self) else { return }

        store.send(.updateProfileImage(data))
      }
    }
    .setRequestFlightView(isLoading: isLoading)
    .onAppear {
      store.send(.getUserInfo)
    }
    .onDisappear {
      store.send(.teardown)
    }
  }
}
