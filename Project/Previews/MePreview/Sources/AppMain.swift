import Architecture
import FirebaseAuth
import LinkNavigator
import SwiftUI

// MARK: - AppMain

struct AppMain {
  let viewModel: AppViewModel
}

// MARK: View

extension AppMain: View {

  var body: some View {
//    LinkNavigationView(
//      linkNavigator: viewModel.linkNavigator,
//      item: .init(path: Link.Me.Path.me.rawValue))
    LinkNavigationView(
      linkNavigator: viewModel.linkNavigator,
      item: .init(
        path: Auth.auth().currentUser != .none
          ? Link.Me.Path.me.rawValue
          : Link.Authentication.Path.signIn.rawValue))
      .ignoresSafeArea()
      .onAppear { }
  }
}
