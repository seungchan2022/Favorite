import Foundation

// MARK: - Link.Search

extension Link {
  public enum Search { }
}

// MARK: - Link.Search.Path

extension Link.Search {
  public enum Path: String, Equatable {
    case repo
    case user
  }
}
