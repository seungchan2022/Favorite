import Architecture
import Foundation
import Like
import LinkNavigator

struct AppRouteBuilderGroup<RootNavigator: RootNavigatorType> {

  var release: [RouteBuilderOf<RootNavigator>] {
    LikeRouteBuilderGroup.release
      + LikeRouteBuilderGroup.template
  }
}
