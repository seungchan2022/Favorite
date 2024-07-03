import Architecture
import ComposableArchitecture
import Foundation

// MARK: - MeSideEffect

struct MeSideEffect {
  let useCase: MeEnvironmentUsable
  let main: AnySchedulerOf<DispatchQueue>
  let navigator: RootNavigatorType

  init(
    useCase: MeEnvironmentUsable,
    main: AnySchedulerOf<DispatchQueue> = .main,
    navigator: RootNavigatorType)
  {
    self.useCase = useCase
    self.main = main
    self.navigator = navigator
  }
}

extension MeSideEffect {
  var routeToTabBarItem: (String) -> Void {
    { path in
      guard path != Link.Me.Path.me.rawValue else { return }
      navigator.replace(linkItem: .init(path: path), isAnimated: false)
    }
  }
}
