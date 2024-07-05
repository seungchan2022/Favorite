import Architecture
import ComposableArchitecture
import Foundation

// MARK: - UpdatePasswordSideEffect

struct UpdatePasswordSideEffect {
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

extension UpdatePasswordSideEffect {

  var updatePassword: (String) -> Effect<UpdatePasswordReducer.Action> {
    { newPassword in
      .publisher {
        useCase.authUseCase
          .updatePassword(newPassword)
          .map { _ in true }
          .receive(on: main)
          .mapToResult()
          .map(UpdatePasswordReducer.Action.fetchUpdatePassword)
      }
    }
  }

  var routeToClose: () -> Void {
    {
      navigator.close(isAnimated: true, completeAction: { })
    }
  }

}
