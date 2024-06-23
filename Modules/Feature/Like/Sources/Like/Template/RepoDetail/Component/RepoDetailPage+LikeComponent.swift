import Domain
import SwiftUI

// MARK: - RepoDetailPage.LikeComponent

extension RepoDetailPage {
  struct LikeComponent {
    let viewState: ViewState
    let likeAction: (GithubEntity.Detail.Repository.Response) -> Void
  }
}

extension RepoDetailPage.LikeComponent {
  private var likeImage: Image {
    Image(systemName: viewState.isLike ? "heart.fill" : "heart")
  }
}

// MARK: - RepoDetailPage.LikeComponent + View

extension RepoDetailPage.LikeComponent: View {
  var body: some View {
    Button(action: { likeAction(viewState.item) }) {
      likeImage
        .resizable()
    }
  }
}

// MARK: - RepoDetailPage.LikeComponent.ViewState

extension RepoDetailPage.LikeComponent {
  struct ViewState: Equatable {
    let isLike: Bool
    let item: GithubEntity.Detail.Repository.Response
  }
}
