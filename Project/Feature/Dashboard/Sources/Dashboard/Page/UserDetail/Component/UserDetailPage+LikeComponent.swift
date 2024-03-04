import SwiftUI
import Domain

extension UserDetailPage {
  struct LikeComponent {
    let viewState: ViewState
    let likeAction: (GithubEntity.Detail.User.Response) -> Void
  }
}

extension UserDetailPage.LikeComponent {
  private var likeImage: Image {
    Image(systemName: viewState.isLike ? "heart.fill" : "heart")
  }
}

extension UserDetailPage.LikeComponent: View {
  var body: some View {
    Button(action: { likeAction(viewState.item) }) {
      likeImage
        .resizable()
    }
  }
}

extension UserDetailPage.LikeComponent {
  struct ViewState: Equatable {
    let isLike: Bool
    let item: GithubEntity.Detail.User.Response
  }
}
