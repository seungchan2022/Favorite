import ComposableArchitecture
import Dashboard
import Domain
import Foundation
import Platform
import XCTest

// MARK: - UserTests

final class UserTests: XCTestCase {
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
  func test_binding_query_case1() async {
    var newState = UserReducer.State()
    newState.query = "test"
    newState.itemList = []

    let sut = SUT(state: newState)

    await sut.store.send(.set(\.query, "")) { state in
      state.query = ""
    }
  }

  @MainActor
  func test_binding_query_case2() async {
    var newState = UserReducer.State()
    newState.query = "test"
    newState.itemList = ResponseMock().searchResponse.searchUser.successValue.itemList

    let sut = SUT(state: newState)

    await sut.store.send(.set(\.query, "")) { state in
      state.query = ""
      state.itemList = []
    }
  }

  @MainActor
  func test_binding_query_case3() async {
    var newState = UserReducer.State()
    newState.query = ""
    newState.itemList = []

    let sut = SUT(state: newState)

    await sut.store.send(.set(\.query, "test")) { state in
      state.query = "test"
    }
  }

  @MainActor
  func test_binding_query_case4() async {
    var newState = UserReducer.State()
    newState.query = "test"
    newState.itemList = ResponseMock().searchResponse.searchUser.successValue.itemList

    let sut = SUT(state: newState)

    await sut.store.send(.set(\.query, "test1")) { state in
      state.query = "test1"
      state.itemList = []
    }
  }

  @MainActor
  func test_search_success_case() async {
    let sut = SUT()

    let requestMock: GithubEntity.Search.User.Request = .init(query: "test")
    let responseMock: GithubEntity.Search.User.Composite = .init(
      request: requestMock,
      response: ResponseMock().searchResponse.searchUser.successValue)

    await sut.store.send(.set(\.query, "test")) { state in
      state.query = "test"
    }

    await sut.store.send(.search("test")) { state in
      state.fetchSearchItem.isLoading = true
    }

    await sut.scheduler.advance()

    await sut.store.receive(\.fetchSearchItem) { state in
      state.fetchSearchItem.isLoading = false
      state.fetchSearchItem.value = responseMock
      state.itemList = responseMock.response.itemList
    }
  }

  @MainActor
  func test_search_failure_case() async {
    let sut = SUT()

    sut.container.githubSearchUseCaseStub.type = .failure(.invalidTypeCasting)

    await sut.store.send(.set(\.query, "test")) { state in
      state.query = "test"
    }

    await sut.store.send(.search("test")) { state in
      state.fetchSearchItem.isLoading = true
    }

    await sut.scheduler.advance()

    await sut.store.receive(\.fetchSearchItem) { state in
      state.fetchSearchItem.isLoading = false
    }

    await sut.store.receive(\.throwError)
  }

  @MainActor
  func test_fetchSearchItem_case() async {
    let sut = SUT()

    let mock: GithubEntity.Search.User.Composite = .init(
      request: .init(query: "test"),
      response: .init(totalCount: .zero, itemList: []))

    await sut.store.send(.fetchSearchItem(.success(mock))) { state in
      state.fetchSearchItem.isLoading = false
      state.fetchSearchItem.value = mock
    }

    XCTAssertEqual(sut.container.toastViewActionMock.event.sendMessage, 1)
  }

  @MainActor
  func test_routeToDetail_case() async {
    let sut = SUT()

    let pick = ResponseMock().searchResponse.searchUser.successValue.itemList.first

    await sut.store.send(.routeToDetail(pick!))

    XCTAssertEqual(sut.container.linkNavigatorMock.event.next, 1)
  }
}

extension UserTests {
  struct SUT {

    // MARK: Lifecycle

    init(state: UserReducer.State = .init()) {
      let container = AppContainerMock.generate()
      let main = DispatchQueue.test

      self.container = container
      scheduler = main

      store = .init(
        initialState: state,
        reducer: {
          UserReducer(
            sideEffect: .init(
              useCase: container,
              main: main.eraseToAnyScheduler(),
              navigator: container.linkNavigator))
        })
    }

    // MARK: Internal

    let container: AppContainerMock
    let scheduler: TestSchedulerOf<DispatchQueue>
    let store: TestStore<UserReducer.State, UserReducer.Action>
  }

  struct ResponseMock {
    let searchResponse: GithubSearchUseCaseStub.Response = .init()
    init() { }
  }

}
