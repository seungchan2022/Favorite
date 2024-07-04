import ComposableArchitecture
import DesignSystem
import SwiftUI

// MARK: - Focus

private enum Focus {
  case email
  case password
}

// MARK: - SignInPage

struct SignInPage {
  @Bindable var store: StoreOf<SignInReducer>

  @FocusState private var isFocus: Focus?

}

extension SignInPage {
  private var isActiveSignIn: Bool {
    !store.emailText.isEmpty && !store.passwordText.isEmpty
  }

  private var isLoading: Bool {
    store.fetchSignIn.isLoading
  }
}

// MARK: View

extension SignInPage: View {
  var body: some View {
    VStack {
      DesignSystemNavigation(
        barItem: .init(title: "로그인"),
        isShowDivider: true)
      {
        VStack(spacing: 32) {
          VStack(alignment: .leading, spacing: 16) {
            Text("이메일 주소")

            TextField(
              "이메일",
              text: $store.emailText)
              .textInputAutocapitalization(.never)
              .autocorrectionDisabled(true)

            Divider()
              .overlay(isFocus == .email ? .blue : .clear)
          }
          .focused($isFocus, equals: .email)

          VStack(alignment: .leading, spacing: 16) {
            Text("비밀번호")

            Group {
              if store.isShowPassword {
                TextField(
                  "비밀번호",
                  text: $store.passwordText)
              } else {
                SecureField(
                  "비밀번호",
                  text: $store.passwordText)
              }
            }
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled(true)

            Divider()
              .overlay(isFocus == .password ? .blue : .clear)
          }
          .focused($isFocus, equals: .password)
          .overlay(alignment: .trailing) {
            Button(action: { store.isShowPassword.toggle() }) {
              Image(systemName: store.isShowPassword ? "eye" : "eye.slash")
                .foregroundStyle(.black)
                .padding(.trailing, 12)
            }
          }

          Button(action: { store.send(.onTapSignIn) }) {
            Text("로그인")
              .foregroundStyle(.white)
              .frame(height: 50)
              .frame(maxWidth: .infinity)
              .background(.blue)
              .clipShape(RoundedRectangle(cornerRadius: 8))
              .opacity(isActiveSignIn ? 1.0 : 0.3)
          }
          .disabled(!isActiveSignIn)

          HStack {
            Spacer()
            Button(action: { }) {
              Text("비밀번호 찾기")
            }

            Spacer()

            Divider()

            Spacer()

            Button(action: { store.send(.routeToSignUp) }) {
              Text("회원 가입")
            }

            Spacer()
          }
          .padding(.top, 8)
        }
        .padding(16)
      }
    }
    .toolbar(.hidden, for: .navigationBar)
    .setRequestFlightView(isLoading: isLoading)
    .onAppear {
      isFocus = .email
    }
    .onDisappear {
      store.send(.teardown)
    }
  }
}
