import Foundation

// MARK: - Link.Dashboard

extension Link {
  public enum Like { }
}

// MARK: - Link.Dashboard.Path

extension Link.Like {
  public enum Path: String, Equatable {
//    case repo
//    case repoDetail
//    case user
//    case userDetail
//    case profile
//    case follower
    case like
  }
}
