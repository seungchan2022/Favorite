import Architecture
import Foundation
import Me
import LinkNavigator

struct AppRouteBuilderGroup<RootNavigator: RootNavigatorType> {

  var release: [RouteBuilderOf<RootNavigator>] {
    MeRouteBuilderGroup.release
      + MeRouteBuilderGroup.template
  }
}
