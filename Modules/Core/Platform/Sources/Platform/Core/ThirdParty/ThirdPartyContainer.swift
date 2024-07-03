import Firebase
import Foundation

// MARK: - ThirdPartyContainer

public class ThirdPartyContainer {
  public init() { }
}

extension ThirdPartyContainer {
  public func connect() {
    FirebaseApp.configure()
  }
}
