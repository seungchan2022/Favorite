import Architecture
import Authentication
import Common
import Foundation
import Like
import LinkNavigator
import Me
import Search

struct AppRouteBuilderGroup<RootNavigator: RootNavigatorType> {

  var release: [RouteBuilderOf<RootNavigator>] {
    SearchRouteBuilderGroup.release
      + CommonRouteBuilderGroup.release
      + LikeRouteBuilderGroup.release
      + AuthenticationRouteBuilderGroup.release
      + MeRouteBuilderGroup.release
  }
}
