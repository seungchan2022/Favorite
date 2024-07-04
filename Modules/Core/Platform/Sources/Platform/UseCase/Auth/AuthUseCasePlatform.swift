import Combine
import Domain
import FirebaseAuth

// MARK: - AuthUseCasePlatform

public struct AuthUseCasePlatform {
  public init() { }
}

// MARK: AuthUseCase

extension AuthUseCasePlatform: AuthUseCase {
  public var signUpEmail: (Domain.Auth.Email.Request) -> AnyPublisher<Void, CompositeErrorRepository> {
    { req in
      Future<Void, CompositeErrorRepository> { promise in
        Auth.auth().createUser(withEmail: req.email, password: req.password) { _, error in
          guard let error else { return promise(.success(Void())) }

          return promise(.failure(.other(error)))
        }
      }
      .eraseToAnyPublisher()
    }
  }

  public var signInEmail: (Domain.Auth.Email.Request) -> AnyPublisher<Void, CompositeErrorRepository> {
    { req in
      Future<Void, CompositeErrorRepository> { promise in
        Auth.auth().signIn(withEmail: req.email, password: req.password) { _, error in
          guard let error else { return promise(.success(Void())) }

          return promise(.failure(.other(error)))
        }
      }
      .eraseToAnyPublisher()
    }
  }

  public var signOut: () -> AnyPublisher<Void, CompositeErrorRepository> {
    {
      Future<Void, CompositeErrorRepository> { promise in
        do {
          try Auth.auth().signOut()
          return promise(.success(Void()))
        } catch {
          return promise(.failure(.other(error)))
        }
      }
      .eraseToAnyPublisher()
    }
  }

  public var me: () -> AnyPublisher<Domain.Auth.Me.Response?, CompositeErrorRepository> {
    {
      Future<Domain.Auth.Me.Response?, CompositeErrorRepository> { promise in
        
        guard let me = Auth.auth().currentUser else {
          return promise(.success(.none))
        }
        
        return promise(.success(me.serialized()))
        
      }
      .eraseToAnyPublisher()
    }
  }
  
  public var updateUserName: (String) -> AnyPublisher<Void, CompositeErrorRepository> {
    { name in
      Future<Void, CompositeErrorRepository> { promise in
        guard let me = Auth.auth().currentUser else {
          return promise(.success(Void()))
        }
        
        let changeRequest = me.createProfileChangeRequest()
        
        changeRequest.displayName = name
        changeRequest.photoURL = URL(string: name)
        changeRequest.commitChanges { error in
          guard let error else {
            return promise(.success(Void()))
          }
          
          return promise(.failure(.other(error)))
        }
        
      }
      .eraseToAnyPublisher()
    }
  }
}

extension User {
  fileprivate func serialized() -> Domain.Auth.Me.Response {
    .init(
      uid: uid,
      userName: displayName,
      email: email,
      photoURL: photoURL?.absoluteString)
  }
}
