import Combine

public protocol AuthUseCase {
  var signUpEmail: (Auth.Email.Request) -> AnyPublisher<Void, CompositeErrorRepository> { get }
  var signInEmail: (Auth.Email.Request) -> AnyPublisher<Void, CompositeErrorRepository> { get }

  var signOut: () -> AnyPublisher<Void, CompositeErrorRepository> { get }
  var me: () -> AnyPublisher<Auth.Me.Response?, CompositeErrorRepository> { get }

  var updateUserName: (String) -> AnyPublisher<Void, CompositeErrorRepository> { get }
  var updatePassword: (String) -> AnyPublisher<Void, CompositeErrorRepository> { get }
}
