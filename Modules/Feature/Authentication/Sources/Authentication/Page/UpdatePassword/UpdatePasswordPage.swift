import ComposableArchitecture
import DesignSystem
import Functor
import SwiftUI

// MARK: - Focus

private enum Focus {
  case password
  case confirmPassword
}

// MARK: - UpdatePasswordPage

struct UpdatePasswordPage {
  @Bindable var store: StoreOf<UpdatePasswordReducer>
  @FocusState private var isFocus: Focus?

}

extension UpdatePasswordPage {

  private var isActiveUpdatePassword: Bool {
    Validator.validatePassword(password: store.passwordText)
      && isValidConfirmPassword(text: store.confirmPasswordText)
  }

  private var isLoading: Bool {
    store.fetchUpdatePassword.isLoading
  }

  private func isValidConfirmPassword(text: String) -> Bool {
    store.passwordText == text
  }
}

// MARK: View

extension UpdatePasswordPage: View {
  var body: some View {
    VStack {
      DesignSystemNavigation(
        barItem: .init(
          backAction: .init(
            image: Image(systemName: "xmark"),
            action: { store.send(.routeToClose) }),
          title: "비밀번호 변경",
          moreActionList: []),
        isShowDivider: true)
      {
        VStack(spacing: 32) {
          VStack(alignment: .leading, spacing: 16) {
            Text("변경할 비밀번호")

            Group {
              if store.isShowPassword {
                TextField(
                  "변경할 비밀번호",
                  text: $store.passwordText)
              } else {
                SecureField(
                  "변경할 비밀번호",
                  text: $store.passwordText)
              }
            }
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled(true)
            .onChange(of: store.passwordText) { _, new in
              store.isValidPassword = Validator.validatePassword(password: new)
            }

            Divider()
              .overlay(!store.isValidPassword ? .red : isFocus == .password ? .blue : .clear)

            if !store.isValidPassword {
              HStack {
                Text("영어대문자, 숫자, 특수문자를 모두 사용하여 8 ~ 20자리로 설정해주세요.")
                  .font(.footnote)
                  .foregroundStyle(.red)

                Spacer()
              }
            }
          }
          .focused($isFocus, equals: .password)
          .overlay(alignment: .trailing) {
            Button(action: { store.isShowPassword.toggle() }) {
              Image(systemName: store.isShowPassword ? "eye" : "eye.slash")
                .foregroundStyle(.black)
                .padding(.trailing, 12)
            }
          }

          VStack(alignment: .leading, spacing: 16) {
            Text("비밀번호 확인")

            Group {
              if store.isShowConfirmPassword {
                TextField(
                  "비밀번호 확인",
                  text: $store.confirmPasswordText)
              } else {
                SecureField(
                  "비밀번호 확인",
                  text: $store.confirmPasswordText)
              }
            }
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled(true)
            .onChange(of: store.confirmPasswordText) { _, new in
              store.isValidConfirmPassword = isValidConfirmPassword(text: new)
            }

            Divider()
              .overlay(!store.isValidConfirmPassword ? .red : isFocus == .confirmPassword ? .blue : .clear)

            if !store.isValidConfirmPassword {
              HStack {
                Text("비밀번호가 일치하지 않습니다.")
                  .font(.footnote)
                  .foregroundStyle(.red)

                Spacer()
              }
            }
          }
          .focused($isFocus, equals: .confirmPassword)
          .overlay(alignment: .trailing) {
            Button(action: { store.isShowConfirmPassword.toggle() }) {
              Image(systemName: store.isShowConfirmPassword ? "eye" : "eye.slash")
                .foregroundStyle(.black)
                .padding(.trailing, 12)
            }
          }

          Button(action: { store.send(.onTapUpdatePassword) }) {
            Text("비밀번호 변경")
              .foregroundStyle(.white)
              .frame(height: 50)
              .frame(maxWidth: .infinity)
              .background(.blue)
              .clipShape(RoundedRectangle(cornerRadius: 8))
              .opacity(isActiveUpdatePassword ? 1.0 : 0.3)
          }
          .disabled(!isActiveUpdatePassword)
        }
        .padding(16)
      }
    }

    .toolbar(.hidden, for: .navigationBar)
    .setRequestFlightView(isLoading: isLoading)
    .onAppear { }
    .onDisappear {
      store.send(.teardown)
    }
  }
}
