import Architecture
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
  
  var updateUserName: (String) -> Effect<MeReducer.Action> {
    { newName in
      .publisher {
        useCase.authUseCase
          .updateUserName(newName)
          .map { _ in true }
          .receive(on: main)
          .mapToResult()
          .map(MeReducer.Action.fetchUpdateUserName)
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
  
  var routeToTabBarItem: (String) -> Void {
    { path in
      guard path != Link.Me.Path.me.rawValue else { return }
      navigator.replace(linkItem: .init(path: path), isAnimated: false)
    }
  }
}
