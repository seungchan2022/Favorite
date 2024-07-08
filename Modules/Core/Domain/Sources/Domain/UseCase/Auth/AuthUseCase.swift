import Combine
import Foundation

public protocol AuthUseCase {
  var signUpEmail: (Auth.Email.Request) -> AnyPublisher<Void, CompositeErrorRepository> { get }
  var signInEmail: (Auth.Email.Request) -> AnyPublisher<Void, CompositeErrorRepository> { get }

  var signOut: () -> AnyPublisher<Void, CompositeErrorRepository> { get }
  var me: () -> AnyPublisher<Auth.Me.Response?, CompositeErrorRepository> { get }

  var updateUserName: (String) -> AnyPublisher<Void, CompositeErrorRepository> { get }
  var updatePassword: (String, String) -> AnyPublisher<Void, CompositeErrorRepository> { get }

  var uploadProfileImage: (Data) -> AnyPublisher<String, CompositeErrorRepository> { get }

  var updateProfileImageURL: (String) -> AnyPublisher<Void, CompositeErrorRepository> { get }

  var resetPassword: (String) -> AnyPublisher<Void, CompositeErrorRepository> { get }

  var deleteUser: (String) -> AnyPublisher<Void, CompositeErrorRepository> { get }
}
