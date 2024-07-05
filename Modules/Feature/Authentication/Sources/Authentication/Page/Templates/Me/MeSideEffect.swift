import Architecture
import Combine
import CombineExt
import ComposableArchitecture
import Foundation

// MARK: - MeSideEffect

struct MeSideEffect {
  let useCase: AuthenticationEnvironmentUsable
  let main: AnySchedulerOf<DispatchQueue>
  let navigator: RootNavigatorType

  init(
    useCase: AuthenticationEnvironmentUsable,
    main: AnySchedulerOf<DispatchQueue> = .main,
    navigator: RootNavigatorType)
  {
    self.useCase = useCase
    self.main = main
    self.navigator = navigator
  }
}

extension MeSideEffect {
  var userInfo: () -> Effect<MeReducer.Action> {
    {
      .publisher {
        useCase.authUseCase
          .me()
          .receive(on: main)
          .mapToResult()
          .map(MeReducer.Action.fetchUserInfo)
      }
    }
  }

  var signOut: () -> Effect<MeReducer.Action> {
    {
      .publisher {
        useCase.authUseCase.signOut()
          .map { _ in true }
          .receive(on: main)
          .mapToResult()
          .map(MeReducer.Action.fetchSignOut)
      }
    }
  }

  var routeToSignIn: () -> Void {
    {
      navigator.replace(
        linkItem: .init(path: Link.Authentication.Path.signIn.rawValue),
        isAnimated: false)
    }
  }

  var routeToUpdateAuth: () -> Void {
    {
      navigator.next(
        linkItem: .init(path: Link.Authentication.Path.updateAuth.rawValue),
        isAnimated: true)
    }
  }

  var routeToTabBarItem: (String) -> Void {
    { path in
      guard path != Link.Me.Path.me.rawValue else { return }
      navigator.replace(linkItem: .init(path: path), isAnimated: false)
    }
  }
}
