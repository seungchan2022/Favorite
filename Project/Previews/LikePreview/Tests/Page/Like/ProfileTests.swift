import ComposableArchitecture
import Dashboard
import Domain
import Foundation
import Platform
import XCTest

// MARK: - ProfileTests

final class ProfileTests: XCTestCase {
  override class func tearDown() {
    super.tearDown()
  }

  @MainActor
  func test_teardown() async {
    let sut = SUT()

    await sut.store.send(.teardown)
  }

  @MainActor
  func test_binding() async {
    let sut = SUT()

    await sut.store.send(.set(\.fetchIsLike, .init(isLoading: false, value: false)))
  }

  @MainActor
  func test_getItem_success_case() async {
    let sut = SUT()

    let responseMock: GithubEntity.Detail.User.Response = ResponseMock().detailResponse.user.successValue

    await sut.store.send(.getItem) { state in
      state.fetchItem.isLoading = true
    }

    await sut.scheduler.advance()

    await sut.store.receive(\.fetchItem) { state in
      state.fetchItem.isLoading = false
      state.fetchItem.value = responseMock
    }
  }

  @MainActor
  func test_getItem_failure_case() async {
    let sut = SUT()

    sut.container.githubDetailUseCaseStub.type = .failure(.invalidTypeCasting)

    await sut.store.send(.getItem) { state in
      state.fetchItem.isLoading = true
    }

    await sut.scheduler.advance()

    await sut.store.receive(\.fetchItem) { state in
      state.fetchItem.isLoading = false
    }

    await sut.store.receive(\.throwError)
  }

  @MainActor
  func test_getIsLike_success_case1() async {
    let sut = SUT()

    let responseMock: GithubEntity.Detail.User.Response = ResponseMock().detailResponse.user.successValue

    /// - Note: 해당 아이템이 좋아요가 아닌 상태 => UnLike 상태
    sut.container.githubLikeUseCaseFake.reset()

    await sut.store.send(.getIsLike(responseMock)) { state in
      state.fetchIsLike.isLoading = true
    }

    await sut.scheduler.advance()

    await sut.store.receive(\.fetchIsLike) { state in
      state.fetchIsLike.isLoading = false
      state.fetchIsLike.value = false
    }
  }

  @MainActor
  func test_getIsLike_success_case2() async {
    let sut = SUT()

    let responseMock: GithubEntity.Detail.User.Response = ResponseMock().detailResponse.user.successValue

    /// - Note: 해당 아이템이 좋아요인 상태 => Like 상태
    sut.container.githubLikeUseCaseFake.reset(
      store: .init(userList: [responseMock]))

    await sut.store.send(.getIsLike(responseMock)) { state in
      state.fetchIsLike.isLoading = true
    }

    await sut.scheduler.advance()

    await sut.store.receive(\.fetchIsLike) { state in
      state.fetchIsLike.isLoading = false
      state.fetchIsLike.value = true
    }
  }

  @MainActor
  func test_updateIsLike_success_case1() async {
    let sut = SUT()

    let responseMock: GithubEntity.Detail.User.Response = ResponseMock().detailResponse.user.successValue

    /// - Note: 해당 아이템이 좋아요가 아닌 상태 => UnLike 상태
    sut.container.githubLikeUseCaseFake.reset()

    await sut.store.send(.updateIsLike(responseMock)) { state in
      state.fetchIsLike.isLoading = true
    }

    await sut.scheduler.advance()

    await sut.store.receive(\.fetchIsLike) { state in
      state.fetchIsLike.isLoading = false
      /// - Note: 아이템이 좋아요가 아닌 상태였는데,
      /// updateIsLike를 수행했으므로 좋아요인 상태로 변경 ( UnLike => Like)
      state.fetchIsLike.value = true
    }
  }

  @MainActor
  func test_updateIsLike_success_case2() async {
    let sut = SUT()

    let responseMock: GithubEntity.Detail.User.Response = ResponseMock().detailResponse.user.successValue

    /// - Note: 해당 아이템이 좋아요 상태 => Like 상태
    sut.container.githubLikeUseCaseFake.reset(
      store: .init(userList: [responseMock]))

    await sut.store.send(.updateIsLike(responseMock)) { state in
      state.fetchIsLike.isLoading = true
    }

    await sut.scheduler.advance()

    await sut.store.receive(\.fetchIsLike) { state in
      state.fetchIsLike.isLoading = false
      /// - Note: 아이템이 좋아요 상태였는데,
      /// updateIsLike를 수행했으므로 좋아요가 아닌 상태로 변경 (Like => UnLike)
      state.fetchIsLike.value = false
    }
  }

  @MainActor
  func test_fetchIsLike_failure_case() async {
    let sut = SUT()

    await sut.store.send(.fetchIsLike(.failure(.invalidTypeCasting)))

    await sut.scheduler.advance()

    await sut.store.receive(\.throwError)

    XCTAssertEqual(sut.container.toastViewActionMock.event.sendErrorMessage, 1)
  }

}

extension ProfileTests {
  struct SUT {

    // MARK: Lifecycle

    init(state: ProfileReducer.State = .init(item: .init(ownerName: "interactord"))) {
      let container = AppContainerMock.generate()
      let main = DispatchQueue.test

      self.container = container
      scheduler = main

      store = .init(
        initialState: state,
        reducer: {
          ProfileReducer(
            sideEffect: .init(
              useCase: container,
              main: main.eraseToAnyScheduler(),
              navigator: container.linkNavigator))
        })
    }

    // MARK: Internal

    let container: AppContainerMock
    let scheduler: TestSchedulerOf<DispatchQueue>
    let store: TestStore<ProfileReducer.State, ProfileReducer.Action>
  }

  struct ResponseMock {
    let detailResponse: GithubDetailUseCaseStub.Response = .init()
    init() { }
  }
}
