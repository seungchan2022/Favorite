// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length line_length implicit_return

// MARK: - Files

// swiftlint:disable explicit_type_interface identifier_name
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum Files {
  /// detail_repositories_failure.json
  internal static let detailRepositoriesFailureJson = File(name: "detail_repositories_failure", ext: "json", relativePath: "", mimeType: "application/json")
  /// detail_repositories_success.json
  internal static let detailRepositoriesSuccessJson = File(name: "detail_repositories_success", ext: "json", relativePath: "", mimeType: "application/json")
  /// detail_users_failure.json
  internal static let detailUsersFailureJson = File(name: "detail_users_failure", ext: "json", relativePath: "", mimeType: "application/json")
  /// detail_users_success.json
  internal static let detailUsersSuccessJson = File(name: "detail_users_success", ext: "json", relativePath: "", mimeType: "application/json")
  /// dummy.json
  internal static let dummyJson = File(name: "dummy", ext: "json", relativePath: "", mimeType: "application/json")
  /// search_repositories_failure.json
  internal static let searchRepositoriesFailureJson = File(name: "search_repositories_failure", ext: "json", relativePath: "", mimeType: "application/json")
  /// search_repositories_success.json
  internal static let searchRepositoriesSuccessJson = File(name: "search_repositories_success", ext: "json", relativePath: "", mimeType: "application/json")
  /// search_users_failure.json
  internal static let searchUsersFailureJson = File(name: "search_users_failure", ext: "json", relativePath: "", mimeType: "application/json")
  /// search_users_success.json
  internal static let searchUsersSuccessJson = File(name: "search_users_success", ext: "json", relativePath: "", mimeType: "application/json")
  /// user_followers_failure.json
  internal static let userFollowersFailureJson = File(name: "user_followers_failure", ext: "json", relativePath: "", mimeType: "application/json")
  /// user_followers_success.json
  internal static let userFollowersSuccessJson = File(name: "user_followers_success", ext: "json", relativePath: "", mimeType: "application/json")
}
// swiftlint:enable explicit_type_interface identifier_name
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

internal struct File {
  internal let name: String
  internal let ext: String?
  internal let relativePath: String
  internal let mimeType: String

  internal var url: URL {
    return url(locale: nil)
  }

  internal func url(locale: Locale?) -> URL {
    let bundle = BundleToken.bundle
    let url = bundle.url(
      forResource: name,
      withExtension: ext,
      subdirectory: relativePath,
      localization: locale?.identifier
    )
    guard let result = url else {
      let file = name + (ext.flatMap { ".\($0)" } ?? "")
      fatalError("Could not locate file named \(file)")
    }
    return result
  }

  internal var path: String {
    return path(locale: nil)
  }

  internal func path(locale: Locale?) -> String {
    return url(locale: locale).path
  }
}

// swiftlint:disable convenience_type explicit_type_interface
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type explicit_type_interface
