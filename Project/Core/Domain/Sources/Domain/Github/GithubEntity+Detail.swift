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
    public let login: String
    
    public init(login: String) {
      self.login = login
    }
  }
  
  public struct Response: Equatable, Codable, Sendable {
    public let name: String
    public let htmlURL: String
    
    private enum CodingKeys: String, CodingKey {
      case name
      case htmlURL = "html_url"
    }
  }
}

