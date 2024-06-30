import ComposableArchitecture
import Domain
import Foundation
import Platform
import Search
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

    await sut.store.send(.set(\.fetchIsCommon, .init(isLoading: false, value: false)))
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
  func test_getIsCommon_success_case1() async {
    let sut = SUT()

    let responseMock: GithubEntity.Detail.User.Response = ResponseMock().detailResponse.user.successValue

    /// - Note: 해당 아이템이 좋아요가 아닌 상태 => UnCommon 상태
    sut.container.githubCommonUseCaseFake.reset()

    await sut.store.send(.getIsCommon(responseMock)) { state in
      state.fetchIsCommon.isLoading = true
    }

    await sut.scheduler.advance()

    await sut.store.receive(\.fetchIsCommon) { state in
      state.fetchIsCommon.isLoading = false
      state.fetchIsCommon.value = false
    }
  }

  @MainActor
  func test_getIsCommon_success_case2() async {
    let sut = SUT()

    let responseMock: GithubEntity.Detail.User.Response = ResponseMock().detailResponse.user.successValue

    /// - Note: 해당 아이템이 좋아요인 상태 => Common 상태
    sut.container.githubCommonUseCaseFake.reset(
      store: .init(userList: [responseMock]))

    await sut.store.send(.getIsCommon(responseMock)) { state in
      state.fetchIsCommon.isLoading = true
    }

    await sut.scheduler.advance()

    await sut.store.receive(\.fetchIsCommon) { state in
      state.fetchIsCommon.isLoading = false
      state.fetchIsCommon.value = true
    }
  }

  @MainActor
  func test_updateIsCommon_success_case1() async {
    let sut = SUT()

    let responseMock: GithubEntity.Detail.User.Response = ResponseMock().detailResponse.user.successValue

    /// - Note: 해당 아이템이 좋아요가 아닌 상태 => UnCommon 상태
    sut.container.githubCommonUseCaseFake.reset()

    await sut.store.send(.updateIsCommon(responseMock)) { state in
      state.fetchIsCommon.isLoading = true
    }

    await sut.scheduler.advance()

    await sut.store.receive(\.fetchIsCommon) { state in
      state.fetchIsCommon.isLoading = false
      /// - Note: 아이템이 좋아요가 아닌 상태였는데,
      /// updateIsCommon를 수행했으므로 좋아요인 상태로 변경 ( UnCommon => Common)
      state.fetchIsCommon.value = true
    }
  }

  @MainActor
  func test_updateIsCommon_success_case2() async {
    let sut = SUT()

    let responseMock: GithubEntity.Detail.User.Response = ResponseMock().detailResponse.user.successValue

    /// - Note: 해당 아이템이 좋아요 상태 => Common 상태
    sut.container.githubCommonUseCaseFake.reset(
      store: .init(userList: [responseMock]))

    await sut.store.send(.updateIsCommon(responseMock)) { state in
      state.fetchIsCommon.isLoading = true
    }

    await sut.scheduler.advance()

    await sut.store.receive(\.fetchIsCommon) { state in
      state.fetchIsCommon.isLoading = false
      /// - Note: 아이템이 좋아요 상태였는데,
      /// updateIsCommon를 수행했으므로 좋아요가 아닌 상태로 변경 (Common => UnCommon)
      state.fetchIsCommon.value = false
    }
  }

  @MainActor
  func test_fetchIsCommon_failure_case() async {
    let sut = SUT()

    await sut.store.send(.fetchIsCommon(.failure(.invalidTypeCasting)))

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
