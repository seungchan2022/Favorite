import ComposableArchitecture
import Domain
import Foundation
import Platform
import Search
import XCTest

// MARK: - MeTests

final class MeTests: XCTestCase {
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

    await sut.store.send(.set(\.itemList, .init()))
  }

  @MainActor
  func test_getItemList_success_case() async {
    let sut = SUT()

    /// - Note: Repo와 User에 대한 Mock을 만듬
    let repoMock: GithubEntity.Detail.Repository.Response = ResponseMock().detailReponse.repository.successValue
    let userMock: GithubEntity.Detail.User.Response = ResponseMock().detailReponse.user.successValue

    /// - Note: Repo와 User에 대한 Mocke을 Me에 설정
    let responeMock: GithubEntity.Me = .init(
      repoList: [repoMock],
      userList: [userMock])

    /// - Note: 좋아요 눌린 리스트에 들어가도록
    sut.container.githubMeUseCaseFake.reset(
      store: .init(
        repoList: [repoMock],
        userList: [userMock]))

    await sut.store.send(.getItemList) { state in
      state.fetchItemList.isLoading = true
    }

    await sut.scheduler.advance()

    await sut.store.receive(\.fetchItemList) { state in
      state.fetchItemList.isLoading = false
      state.fetchItemList.value = responeMock
      state.itemList = responeMock
    }
  }

  @MainActor
  func test_fetchItemList_failure_case() async {
    let sut = SUT()

    await sut.store.send(.fetchItemList(.failure(.invalidTypeCasting)))

    await sut.scheduler.advance()

    await sut.store.receive(\.throwError)

    XCTAssertEqual(sut.container.toastViewActionMock.event.sendErrorMessage, 1)
  }

  @MainActor
  func test_routeToRepoDetail_case() async {
    let sut = SUT()

    let pick: GithubEntity.Detail.Repository.Response = ResponseMock().detailReponse.repository.successValue

    await sut.store.send(.routeToRepoDetail(pick))

    XCTAssertEqual(sut.container.linkNavigatorMock.event.next, 1)
  }

  @MainActor
  func test_routeToUserDetail_case() async {
    let sut = SUT()

    let pick: GithubEntity.Detail.User.Response = ResponseMock().detailReponse.user.successValue

    await sut.store.send(.routeToUserDetail(pick))

    XCTAssertEqual(sut.container.linkNavigatorMock.event.next, 1)
  }
}

extension MeTests {
  struct SUT {

    // MARK: Lifecycle

    init(state: MeReducer.State = .init()) {
      let container = AppContainerMock.generate()
      let main = DispatchQueue.test

      self.container = container
      scheduler = main

      store = .init(
        initialState: state,
        reducer: {
          MeReducer(
            sideEffect: .init(
              useCase: container,
              main: main.eraseToAnyScheduler(),
              navigator: container.linkNavigator))
        })
    }

    // MARK: Internal

    let container: AppContainerMock
    let scheduler: TestSchedulerOf<DispatchQueue>
    let store: TestStore<MeReducer.State, MeReducer.Action>
  }

  struct ResponseMock {
    /// - Note: 좋아요 눌린 항목들을 가져와야 되므로, 좋아요를 눌린 항목은
    /// Repo와 User의 Detail 항목이다
    let detailReponse: GithubDetailUseCaseStub.Response = .init()
    init() { }
  }
}
