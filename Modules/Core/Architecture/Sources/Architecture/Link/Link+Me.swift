import Foundation

extension Link {
  public enum Me { }
}

extension Link.Me {
  public enum Path: String, Equatable {
    case me
  }
}
