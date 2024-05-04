import ComposableArchitecture
import Dashboard
import Domain
import Foundation
import Platform
import XCTest

// MARK: - RepoDetailTests

final class RepoDetailTests: XCTestCase {
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
    
    await sut.store.send(.set(\.fetchIsLike, .init(isLoading: false, value: true))) { state in
      state.fetchIsLike.value = true
    }
  }

  @MainActor
  func test_getDetail_success_case() async {
    let sut = SUT()

    /// 이미 State에 대한 item에 대해서 request를 설정해두었기 때문에 response만 가져옴
    let responseMock: GithubEntity.Detail.Repository.Response = ResponseMock().detailResponse.repository.successValue

    await sut.store.send(.getDetail) { state in
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

    await sut.store.send(.getDetail) { state in
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
    let responseMock: GithubEntity.Detail.Repository.Response = ResponseMock().detailResponse.repository.successValue

    let sut = SUT()

    /// - Note: Like 리스트에 해당 아이템이 없음
    sut.container.githubLikeUseCaseFake.reset()

    await sut.store.send(.getIsLike(responseMock)) { state in
      state.fetchIsLike.isLoading = true
    }

    await sut.scheduler.advance()

    await sut.store.receive(\.fetchIsLike) { state in
      state.fetchIsLike.isLoading = false
      /// - Note: 현재 아이템이 Like가 아니므로 false
      state.fetchIsLike.value = false
    }
  }

  @MainActor
  func test_getIsLike_success_case2() async {
    let responseMock: GithubEntity.Detail.Repository.Response = ResponseMock().detailResponse.repository.successValue

    let sut = SUT()

    /// - Note: Like 리스트에 해당 아이템이 있음 => 좋아요인 상태
    sut.container.githubLikeUseCaseFake.reset(store: .init(repoList: [responseMock]))

    await sut.store.send(.getIsLike(responseMock)) { state in
      state.fetchIsLike.isLoading = true
    }

    await sut.scheduler.advance()

    await sut.store.receive(\.fetchIsLike) { state in
      state.fetchIsLike.isLoading = false
      /// - Note: 현재 아이템이 Like인 상태이므로 true
      state.fetchIsLike.value = true
    }
  }

  @MainActor
  func test_updateIsLike_success_case1() async {
    let responseMock: GithubEntity.Detail.Repository.Response = ResponseMock().detailResponse.repository.successValue

    let sut = SUT()

    /// - Note: 현재 저장된 Repo가 없는 경우 = UnLike인 상태
    sut.container.githubLikeUseCaseFake.reset()

    await sut.store.send(.updateIsLike(responseMock)) { state in
      state.fetchIsLike.isLoading = true
    }

    await sut.scheduler.advance()

    await sut.store.receive(\.fetchIsLike) { state in
      state.fetchIsLike.isLoading = false
      /// - Note: 현재 아이템이 UnLike 상태인데 위에서 updateIsLike를 수행했으므로 Like인 상태(true)로 변경
      state.fetchIsLike.value = true
    }
  }

  @MainActor
  func test_updateIsLike_success_case2() async {
    let responseMock: GithubEntity.Detail.Repository.Response = ResponseMock().detailResponse.repository.successValue

    let sut = SUT()

    /// - Note: 현재 Repo가 좋아요 리스트에 있는 상태 = Like
    sut.container.githubLikeUseCaseFake.reset(store: .init(repoList: [responseMock]))

    await sut.store.send(.updateIsLike(responseMock)) { state in
      state.fetchIsLike.isLoading = true
    }

    await sut.scheduler.advance()

    await sut.store.receive(\.fetchIsLike) { state in
      state.fetchIsLike.isLoading = false
      /// - Note: 현재 아이템이 Like 상태인데 위에서 updateIsLike를 수행했으므로 UnLike인 상태(false) 로 변경
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

extension RepoDetailTests {
  struct SUT {

    // MARK: Lifecycle

    /// Repo  -> RepoDetail 로 이동할때 Repo에서 넘긴 query에 대한 정보를 담은 상태로
    /// RepoDetail 페이지가 나오는 것이기 때문에 Requst에 아무 값을 설정해둠
    init(state: RepoDetailReducer.State = .init(
      item: GithubEntity.Detail.Repository.Request(
        ownerName: "apple",
        repositoryname: "swift")))
    {
      let container = AppContainerMock.generate()
      let main = DispatchQueue.test

      self.container = container
      scheduler = main

      store = .init(
        initialState: state,
        reducer: {
          RepoDetailReducer(
            sideEffect: .init(
              useCase: container,
              main: main.eraseToAnyScheduler(),
              navigator: container.linkNavigator))
        })
    }

    // MARK: Internal

    let container: AppContainerMock
    let scheduler: TestSchedulerOf<DispatchQueue>
    let store: TestStore<RepoDetailReducer.State, RepoDetailReducer.Action>

  }

  struct ResponseMock {
    let detailResponse: GithubDetailUseCaseStub.Response = .init()
    init() { }
  }
}
