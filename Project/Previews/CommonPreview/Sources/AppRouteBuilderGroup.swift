import Architecture
import Common
import Foundation
import LinkNavigator

struct AppRouteBuilderGroup<RootNavigator: RootNavigatorType> {

  var release: [RouteBuilderOf<RootNavigator>] {
    CommonRouteBuilderGroup.release
      + CommonRouteBuilderGroup.template
  }
}
