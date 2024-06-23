import ComposableArchitecture
import Dashboard
import Domain
import Foundation
import Platform
import XCTest

// MARK: - FollowersTests

final class FollowersTests: XCTestCase {
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

    await sut.store.send(.set(\.itemList, []))
  }

  @MainActor
  func test_getItem_success_case() async {
    let sut = SUT()

    let requestMock: GithubEntity.User.Follower.Request = .init(ownerName: "interactord")
    let responseMock: [GithubEntity.User.Follower.Response] = ResponseMock().followerResponse.follower.successValue

    await sut.store.send(.getItem(requestMock)) { state in
      state.fetchItem.isLoading = true
    }

    await sut.scheduler.advance()

    await sut.store.receive(\.fetchItem) { state in
      state.fetchItem.isLoading = false
      state.fetchItem.value = responseMock
      state.itemList = responseMock
    }
  }

  @MainActor
  func test_getItem_failure_case() async {
    let sut = SUT()

    sut.container.githubUserUseCaseStub.type = .failure(.invalidTypeCasting)

    let requestMock: GithubEntity.User.Follower.Request = .init(ownerName: "interactord")

    await sut.store.send(.getItem(requestMock)) { state in
      state.fetchItem.isLoading = true
    }

    await sut.scheduler.advance()

    await sut.store.receive(\.fetchItem) { state in
      state.fetchItem.isLoading = false
    }

    await sut.store.receive(\.throwError)
  }

  @MainActor
  func test_routeToUser_case() async {
    let sut = SUT()

    let pick: GithubEntity.User.Follower.Response = ResponseMock().followerResponse.follower.successValue.first!

    await sut.store.send(.routeToUser(pick))

    XCTAssertEqual(sut.container.linkNavigatorMock.event.next, 1)
  }
}

extension FollowersTests {
  struct SUT {

    // MARK: Lifecycle

    init(state: FollowerReducer.State = .init(item: .init(ownerName: "interactord"))) {
      let container = AppContainerMock.generate()
      let main = DispatchQueue.test

      self.container = container
      scheduler = main

      store = .init(
        initialState: state,
        reducer: {
          FollowerReducer(
            sideEffect: .init(
              useCase: container,
              main: main.eraseToAnyScheduler(),
              navigator: container.linkNavigator))
        })
    }

    // MARK: Internal

    let container: AppContainerMock
    let scheduler: TestSchedulerOf<DispatchQueue>
    let store: TestStore<FollowerReducer.State, FollowerReducer.Action>
  }

  struct ResponseMock {
    let followerResponse: GithubUserUsecCaseStub.Response = .init()
    init() { }
  }
}
