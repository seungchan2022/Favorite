import Architecture
import Combine
import CombineExt
import ComposableArchitecture
import Foundation

// MARK: - UpdateProfileImageSideEffect

struct UpdateProfileImageSideEffect {
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

extension UpdateProfileImageSideEffect {

  var userInfo: () -> Effect<UpdateProfileImageReducer.Action> {
    {
      .publisher {
        useCase.authUseCase
          .me()
          .receive(on: main)
          .mapToResult()
          .map(UpdateProfileImageReducer.Action.fetchUserInfo)
      }
    }
  }

  var updateProfileImage: (Data) -> Effect<UpdateProfileImageReducer.Action> {
    { imageData in
      .publisher {
        useCase.authUseCase.uploadProfileImage(imageData)
          .flatMap { useCase.authUseCase.updateProfileImageURL($0) }
          .map { _ in true }
          .receive(on: main)
          .mapToResult()
          .map(UpdateProfileImageReducer.Action.fetchUpdateProfileImage)
      }
    }
  }

  var routeToBack: () -> Void {
    {
      navigator.back(isAnimated: true)
    }
  }
}
