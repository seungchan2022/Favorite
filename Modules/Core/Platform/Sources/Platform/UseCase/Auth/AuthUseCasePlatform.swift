import Combine
import Domain
import Firebase
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
    { newName in
      Future<Void, CompositeErrorRepository> { promise in
        guard let me = Auth.auth().currentUser else {
          return promise(.success(Void()))
        }

        let changeRequest = me.createProfileChangeRequest()

        changeRequest.displayName = newName
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

  public var updatePassword: (String, String) -> AnyPublisher<Void, CompositeErrorRepository> {
    { currPassword, newPassword in
      Future<Void, CompositeErrorRepository> { promise in

        guard let me = Auth.auth().currentUser else { return promise(.success(Void())) }

        let credential = EmailAuthProvider.credential(withEmail: me.email ?? "", password: currPassword)

        me.reauthenticate(with: credential) { _, error in
          if error != nil {
            return promise(.failure(.currPasswordError))
          } else {
            me.updatePassword(to: newPassword) { error in
              guard let error else { return promise(.success(Void())) }
              return promise(.failure(.other(error)))
            }
          }
        }
      }
      .eraseToAnyPublisher()
    }
  }

  public var resetPassword: (String) -> AnyPublisher<Void, CompositeErrorRepository> {
    { email in
      Future<Void, CompositeErrorRepository> { promise in
        Auth.auth().languageCode = "ko"

        Auth.auth().sendPasswordReset(withEmail: email) { error in
          guard let error else { return promise(.success(Void())) }

          return promise(.failure(.other(error)))
        }
      }
      .eraseToAnyPublisher()
    }
  }

  public var deleteUser: (String) -> AnyPublisher<Void, CompositeErrorRepository> {
    { password in
      Future<Void, CompositeErrorRepository> { promise in
        guard let me = Auth.auth().currentUser else { return promise(.success(Void())) }

        let credential = EmailAuthProvider.credential(withEmail: me.email ?? "", password: password)

        me.reauthenticate(with: credential) { _, error in
          if error != nil {
            return promise(.failure(.currPasswordError))
          } else {
            me.delete { error in
              guard let error else { return promise(.success(Void())) }

              return promise(.failure(.other(error)))
            }
          }
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
