import ComposableArchitecture
import Dashboard
import Domain
import Foundation
import Platform
import XCTest

// MARK: - UserDetailTests

final class UserDetailTests: XCTestCase {
  override class func tearDown() {
    super.tearDown()
  }

  @MainActor
  func test_binding() async {
    let sut = SUT()
    
    await sut.store.send(.set(\.fetchIsLike, .init(isLoading: false, value: true))) { state in
      state.fetchIsLike.value = true
    }
  }

  @MainActor
  func test_teardown() async {
    let sut = SUT()

    await sut.store.send(.teardown)
  }

  @MainActor
  func test_getDetail_success_case() async {
    let sut = SUT()

    let requestMock: GithubEntity.Detail.User.Request = .init(ownerName: "interactord")
    let responseMock: GithubEntity.Detail.User.Response = ResponseMock().detailResponse.user.successValue

    await sut.store.send(.getDetail(requestMock)) { state in
      state.fetchDetailItem.isLoading = true
    }

    await sut.scheduler.advance()

    await sut.store.receive(\.fetchDetailItem) { state in
      state.fetchDetailItem.isLoading = false
      state.fetchDetailItem.value = responseMock
    }
  }

  @MainActor
  func test_getDetail_failure_case() async {
    let sut = SUT()
    sut.container.githubDetailUseCaseStub.type = .failure(.invalidTypeCasting)

    let requestMock: GithubEntity.Detail.User.Request = .init(ownerName: "interactord")

    await sut.store.send(.getDetail(requestMock)) { state in
      state.fetchDetailItem.isLoading = true
    }

    await sut.scheduler.advance()

    await sut.store.receive(\.fetchDetailItem) { state in
      state.fetchDetailItem.isLoading = false
    }

    await sut.store.receive(\.throwError)
  }

  @MainActor
  func test_getIsLike_success_case1() async {
    let sut = SUT()

    let responseMock: GithubEntity.Detail.User.Response = ResponseMock().detailResponse.user.successValue

    /// - Note: 좋아요가 아닌 상태 => UnLike 상태
    sut.container.githubLikeUseCaseFake.reset()

    await sut.store.send(.getIsLike(responseMock)) { state in
      state.fetchIsLike.isLoading = true
    }

    await sut.scheduler.advance()

    await sut.store.receive(\.fetchIsLike) { state in
      state.fetchIsLike.isLoading = false
      /// - Note: 좋아요가 아닌 상태 이므로 fetch한 아이템의 value가 false
      state.fetchIsLike.value = false
    }
  }

  @MainActor
  func test_getIsLike_success_case2() async {
    let sut = SUT()

    let responseMock: GithubEntity.Detail.User.Response = ResponseMock().detailResponse.user.successValue

    /// - Note: 좋아요인  상태 => Like 상태
    sut.container.githubLikeUseCaseFake.reset(store: .init(userList: [responseMock]))

    await sut.store.send(.getIsLike(responseMock)) { state in
      state.fetchIsLike.isLoading = true
    }

    await sut.scheduler.advance()

    await sut.store.receive(\.fetchIsLike) { state in
      state.fetchIsLike.isLoading = false
      /// - Note: 좋아요 상태 이므로 fetch한 아이템의 value가 true
      state.fetchIsLike.value = true
    }
  }

  @MainActor
  func test_updateIsLike_success_case1() async {
    let sut = SUT()

    let responseMock: GithubEntity.Detail.User.Response = ResponseMock().detailResponse.user.successValue

    /// - Note: 현재 아이템이 좋아요가 아닌 상태 => UnLike 상태
    sut.container.githubLikeUseCaseFake.reset()

    await sut.store.send(.updateIsLike(responseMock)) { state in
      state.fetchIsLike.isLoading = true
    }

    await sut.scheduler.advance()

    await sut.store.receive(\.fetchIsLike) { state in
      state.fetchIsLike.isLoading = false
      /// - Note: 좋아요가 아닌 상태에서 updateIsLike를 수행했으로 좋아요인 상태로 변경
      state.fetchIsLike.value = true
    }
  }

  @MainActor
  func test_updateIsLike_success_case2() async {
    let sut = SUT()

    let responseMock: GithubEntity.Detail.User.Response = ResponseMock().detailResponse.user.successValue

    /// - Note: 현재 아이템이 좋아요인 상태 => Like 상태
    sut.container.githubLikeUseCaseFake.reset(store: .init(userList: [responseMock]))

    await sut.store.send(.updateIsLike(responseMock)) { state in
      state.fetchIsLike.isLoading = true
    }

    await sut.scheduler.advance()

    await sut.store.receive(\.fetchIsLike) { state in
      state.fetchIsLike.isLoading = false
      /// - Note: 좋아요인 상태에서 updateIsLike를 수행했으로 좋아요가 아닌  상태로 변경
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

  @MainActor
  func test_routeToProfile_case() async {
    let sut = SUT()

    let pick = ResponseMock().detailResponse.user.successValue

    await sut.store.send(.rouetToProfile(pick))

    XCTAssertEqual(sut.container.linkNavigatorMock.event.next, 1)
  }

  @MainActor
  func test_routeToFollower_case() async {
    let sut = SUT()

    let pick = ResponseMock().detailResponse.user.successValue

    await sut.store.send(.routeToFollower(pick))

    XCTAssertEqual(sut.container.linkNavigatorMock.event.next, 1)
  }

}

extension UserDetailTests {
  struct SUT {

    // MARK: Lifecycle

    init(state: UserDetailReducer.State = .init(item: .init(ownerName: "interactord"))) {
      let container = AppContainerMock.generate()
      let main = DispatchQueue.test

      self.container = container
      scheduler = main

      store = .init(
        initialState: state,
        reducer: {
          UserDetailReducer(
            sideEffect: .init(
              useCase: container,
              main: main.eraseToAnyScheduler(),
              navigator: container.linkNavigatorMock))
        })
    }

    // MARK: Internal

    let container: AppContainerMock
    let scheduler: TestSchedulerOf<DispatchQueue>
    let store: TestStore<UserDetailReducer.State, UserDetailReducer.Action>
  }

  struct ResponseMock {
    let detailResponse: GithubDetailUseCaseStub.Response = .init()
    init() { }
  }
}
