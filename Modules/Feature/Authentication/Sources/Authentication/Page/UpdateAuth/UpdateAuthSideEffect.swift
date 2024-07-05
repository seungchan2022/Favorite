import Architecture
import ComposableArchitecture
import Foundation

struct UpdateAuthSideEffect {
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

extension UpdateAuthSideEffect {
  var userInfo: () -> Effect<UpdateAuthReducer.Action> {
    {
      .publisher {
        useCase.authUseCase
          .me()
          .receive(on: main)
          .mapToResult()
          .map(UpdateAuthReducer.Action.fetchUserInfo)
      }
    }
  }
  
  var signOut: () -> Effect<UpdateAuthReducer.Action> {
    {
      .publisher {
        useCase.authUseCase.signOut()
          .map { _ in true }
          .receive(on: main)
          .mapToResult()
          .map(UpdateAuthReducer.Action.fetchSignOut)
      }
    }
  }
  
  var updateUserName: (String) -> Effect<UpdateAuthReducer.Action> {
    { newName in
      .publisher {
        useCase.authUseCase
          .updateUserName(newName)
          .map { _ in true }
          .receive(on: main)
          .mapToResult()
          .map(UpdateAuthReducer.Action.fetchUpdateUserName)
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
  
  var routeToBack: () -> Void {
    {
      navigator.back(isAnimated: true)
    }
  }
}
