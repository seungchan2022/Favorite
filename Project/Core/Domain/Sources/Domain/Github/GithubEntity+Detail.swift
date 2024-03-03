// MARK: - GithubEntity.Detail

extension GithubEntity {
  public enum Detail {
    public enum Repository { }
    public enum User { }
  }
}

// MARK: - GithubEntity.Profile.Item

extension GithubEntity.Detail.Repository {
  public struct Request: Equatable, Codable, Sendable {
    public let ownerName: String
    public let repositoryname: String

    public init(ownerName: String, repositoryname: String) {
      self.ownerName = ownerName
      self.repositoryname = repositoryname
    }
  }

  public struct Response: Equatable, Codable, Sendable {
    public let fullName: String
    public let htmlURL: String

    private enum CodingKeys: String, CodingKey {
      case fullName = "full_name"
      case htmlURL = "html_url"
    }
  }
}

extension GithubEntity.Detail.User {
  public struct Request: Equatable, Codable, Sendable {
    public let ownerName: String

    public init(ownerName: String) {
      self.ownerName = ownerName
    }
  }

  public struct Response: Equatable, Codable, Sendable {

    // MARK: Public

    public let avatarUrl: String
    public let htmlURL: String
    public let name: String?
    public let loginName: String
    public let location: String?
    public let bio: String?
    public let repoListCount: Int
    public let gistListCount: Int
    public let followerListCount: Int
    public let followingListCount: Int
    public let created: String

    // MARK: Private

    private enum CodingKeys: String, CodingKey {
      case avatarUrl = "avatar_url"
      case htmlURL = "html_url"
      case name
      case loginName = "login"
      case location
      case bio
      case repoListCount = "public_repos"
      case gistListCount = "public_gists"
      case followerListCount = "followers"
      case followingListCount = "following"
      case created = "created_at"
    }
  }
}
