import Architecture
import Foundation
import LinkNavigator
import Me

struct AppRouteBuilderGroup<RootNavigator: RootNavigatorType> {

  var release: [RouteBuilderOf<RootNavigator>] {
    MeRouteBuilderGroup.release
      + MeRouteBuilderGroup.template
  }
}
