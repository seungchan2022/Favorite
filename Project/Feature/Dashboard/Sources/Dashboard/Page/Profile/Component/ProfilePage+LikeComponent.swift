import SwiftUI
import Domain

extension ProfilePage {
  struct LikeComponent {
    let viewState: ViewState
    let likeAction: (GithubEntity.Detail.User.Response) -> Void
  }
}

extension ProfilePage.LikeComponent {
  private var likeImage: Image {
    Image(systemName: viewState.isLike ? "heart.fill" : "heart")
  }
  
}

extension ProfilePage.LikeComponent: View {
  var body: some View {
    Button(action: { likeAction(viewState.item) }) {
      likeImage
        .resizable()
    }
  }
}

extension ProfilePage.LikeComponent {
  struct ViewState: Equatable {
    let isLike: Bool
    let item: GithubEntity.Detail.User.Response
  }
}
