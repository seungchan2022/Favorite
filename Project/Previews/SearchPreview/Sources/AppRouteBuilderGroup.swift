import Architecture
import Foundation
import LinkNavigator
import Search

struct AppRouteBuilderGroup<RootNavigator: RootNavigatorType> {

  var release: [RouteBuilderOf<RootNavigator>] {
    SearchRouteBuilderGroup.release
  }
}
