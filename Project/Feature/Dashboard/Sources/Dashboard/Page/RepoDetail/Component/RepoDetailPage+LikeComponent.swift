import SwiftUI
import Domain

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

extension RepoDetailPage.LikeComponent: View {
  var body: some View {
    Button(action: { likeAction(viewState.item) }) {
      likeImage
        .resizable()
    }
  }
}

extension RepoDetailPage.LikeComponent {
  struct ViewState: Equatable {
    let isLike: Bool
    let item: GithubEntity.Detail.Repository.Response
  }
}

