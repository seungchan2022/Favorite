import Foundation

// MARK: - Auth.Me

extension Auth {
  public enum Me { }
}

// MARK: - Auth.Me.Response

extension Auth.Me {
  public struct Response: Equatable, Sendable, Codable {
    public let uid: String
    public let email: String?
    public let photoURL: String?

    public init(
      uid: String,
      email: String?,
      photoURL: String?)
    {
      self.uid = uid
      self.email = email
      self.photoURL = photoURL
    }
  }
}
