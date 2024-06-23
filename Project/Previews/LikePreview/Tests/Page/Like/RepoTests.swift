import ComposableArchitecture
import Dashboard
import Domain
import Foundation
import Platform
import XCTest

// MARK: - RepoTests

final class RepoTests: XCTestCase {

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
    var newState = RepoReducer.State()
    /// query를 입력했는데
    newState.query = "apple"
    /// 해당 결과가 빈 값
    newState.itemList = []

    let sut = SUT(state: newState)

    await sut.store.send(.set(\.query, "")) { state in
      /// 일반적으로  qurey를 입력한 상태면 결과를 받아오는데 이미  query에 대한 결과값이 빈 값이므로
      /// query에 다시 빈값을 넣었을때 결과 값이 빈값이 라는 조건 필요 없음
      state.query = ""
    }
  }

  @MainActor
  func test_binding_query_case2() async {
    var newState = RepoReducer.State()
    /// query를 입력하고
    newState.query = "apple"
    /// query에 해당 하는 결과 값이 있음
    newState.itemList = ResponseMock().searchResponse.searchRepository.successValue.itemList

    let sut = SUT(state: newState)

    await sut.store.send(.set(\.query, "")) { state in
      /// query에 해당 하는 결과 값이 빈 값이 아니므로
      /// itemList를 빈 값으로 설정
      state.query = ""
      state.itemList = []
    }
  }

  @MainActor
  func test_binding_query_case3() async {
    var newState = RepoReducer.State()
    newState.query = ""
    newState.itemList = []

    let sut = SUT(state: newState)

    await sut.store.send(.set(\.query, "test")) { state in
      state.query = "test"
    }
  }

  @MainActor
  func test_binding_query_case4() async {
    let requestMock: GithubEntity.Search.Repository.Request = .init(query: "apple")
    let responseMock = ResponseMock().searchResponse.searchRepository.successValue

    var newState = RepoReducer.State()
    /// query에 대한 requst를 날리고, response를 받음
    newState.query = requestMock.query
    newState.itemList = responseMock.itemList

    let sut = SUT(state: newState)

    await sut.store.send(.set(\.query, "test")) { state in
      /// request 날린 query와 state의 query가 다르므로 빈 값
      state.query = "test"
      state.itemList = []
    }
  }

  @MainActor
  func test_search_success_case() async {
    let sut = SUT()

    let requestMock: GithubEntity.Search.Repository.Request = .init(query: "apple", page: 1, perPage: 30)
    let responseMock = GithubEntity.Search.Repository.Composite(
      request: requestMock,
      response: ResponseMock().searchResponse.searchRepository.successValue)

    await sut.store.send(.set(\.query, "apple")) { state in
      state.query = "apple"
    }

    await sut.store.send(.search("apple")) { state in
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

    await sut.store.send(.set(\.query, "apple")) { state in
      state.query = "apple"
    }

    await sut.store.send(.search("apple")) { state in
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

    let mock = GithubEntity.Search.Repository.Composite(
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

    let pick = ResponseMock().searchResponse.searchRepository.successValue.itemList.first

    await sut.store.send(.routeToDetail(pick!))

    XCTAssertEqual(sut.container.linkNavigatorMock.event.next, 1)
  }

}

extension RepoTests {
  struct SUT {

    // MARK: Lifecycle

    init(state: RepoReducer.State = .init()) {
      let container = AppContainerMock.generate()
      let main = DispatchQueue.test

      self.container = container
      scheduler = main

      store = .init(
        initialState: state,
        reducer: {
          RepoReducer(
            sideEffect: .init(
              useCase: container,
              main: main.eraseToAnyScheduler(),
              navigator: container.linkNavigator))
        })
    }

    // MARK: Internal

    let container: AppContainerMock
    let scheduler: TestSchedulerOf<DispatchQueue>
    let store: TestStore<RepoReducer.State, RepoReducer.Action>
  }

  struct ResponseMock {
    let searchResponse: GithubSearchUseCaseStub.Response = .init()
    init() { }
  }
}
