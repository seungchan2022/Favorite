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

    // MARK: Public

    public let id: Int
    public let fullName: String
    public let name: String
    public let desc: String?
    public let starCount: Int
    public let watcherCount: Int
    public let forkCount: Int
    public let topicList: [String]
    public let lastUpdate: String
    public let owner: Owner
    public let htmlURL: String?

    // MARK: Private

    private enum CodingKeys: String, CodingKey {
      case id
      case fullName = "full_name"
      case name
      case desc = "description"
      case starCount = "stargazers_count"
      case watcherCount = "watchers_count"
      case forkCount = "forks_count"
      case topicList = "topics"
      case lastUpdate = "updated_at"
      case owner
      case htmlURL = "html_url"
    }
  }

  public struct Owner: Equatable, Codable, Sendable {
    public let id: Int
    public let avatarUrl: String
    public let login: String

    private enum CodingKeys: String, CodingKey {
      case id
      case avatarUrl = "avatar_url"
      case login
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
    public let lastUpdate: String

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
      case lastUpdate = "updated_at"
    }
  }
}
