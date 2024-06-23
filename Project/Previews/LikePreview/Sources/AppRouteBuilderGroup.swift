import Architecture
import Foundation
import LinkNavigator
import Like

struct AppRouteBuilderGroup<RootNavigator: RootNavigatorType> {

  var release: [RouteBuilderOf<RootNavigator>] {
    LikeRouteBuilderGroup.release
    + LikeRouteBuilderGroup.template
  }
}
