extension GithubEntity {
  public enum User {
    public enum Follower { }
  }
}

extension GithubEntity.User.Follower {
  public struct Request: Equatable, Codable, Sendable {
    public let ownerName: String
    
    public init(ownerName: String) {
      self.ownerName = ownerName
    }
  }
  
  public struct Response: Equatable, Codable, Sendable, Identifiable {

    public let id: Int
    public let login: String
    public let avatarUrl: String

    private enum CodingKeys: String, CodingKey {
      case id
      case login
      case avatarUrl = "avatar_url"
    }
  }
}
