// MARK: - GithubEntity.Profile

extension GithubEntity {
  public enum Profile { }
}

// MARK: - GithubEntity.Profile.Item

extension GithubEntity.Profile {
  public struct Item: Equatable, Codable, Sendable {

    // MARK: Public

    public let id: Int
    public let avatarUrl: String
    public let name: String?
    public let loginName: String
    public let location: String?
    public let bio: String?
    public let repos: Int
    public let gists: Int
    public let followers: Int
    public let following: Int
    public let created: String

    // MARK: Private

    private enum CodingKeys: String, CodingKey {
      case id
      case avatarUrl = "avatar_url"
      case name
      case loginName = "login"
      case location
      case bio
      case repos = "public_repos"
      case gists = "public_gists"
      case followers
      case following
      case created = "created_at"
    }
  }
}
