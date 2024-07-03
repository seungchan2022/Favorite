import Architecture
import Common
import Foundation
import Like
import LinkNavigator
import Search
import Authentication
import Me

struct AppRouteBuilderGroup<RootNavigator: RootNavigatorType> {
  
  var release: [RouteBuilderOf<RootNavigator>] {
    SearchRouteBuilderGroup.release
    + CommonRouteBuilderGroup.release
    + LikeRouteBuilderGroup.release
    + AuthenticationRouteBuilderGroup.release
    + MeRouteBuilderGroup.release
  }
}
