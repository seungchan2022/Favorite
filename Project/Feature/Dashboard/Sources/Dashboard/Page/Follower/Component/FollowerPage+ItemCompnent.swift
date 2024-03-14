import DesignSystem
import Domain
import SwiftUI

// MARK: - FollowerPage.ItemComponent

extension FollowerPage {
  struct ItemComponent {
    let viewState: ViewState
    let action: (GithubEntity.User.Follower.Response) -> Void
    
    @Environment(\.colorScheme) var colorScheme
  }
}

extension FollowerPage.ItemComponent { }

// MARK: - FollowerPage.ItemComponent + View

extension FollowerPage.ItemComponent: View {
  var body: some View {
    VStack(spacing: 8) {
      RemoteImage(
        url: viewState.item.avatarUrl,
        placeholder: {
          Rectangle()
            .fill(DesignSystemColor.palette(.gray(.lv100)).color)
        })
        .frame(width: 80, height: 80)
        .clipShape(RoundedRectangle(cornerRadius: 10))

      Text(viewState.item.login)
        .font(.system(size: 14, weight: .bold))
        .foregroundStyle(colorScheme == .dark ? DesignSystemColor.system(.white).color : DesignSystemColor.system(.black).color)
    }
    .frame(width: 80, height: 120)
    .padding(4)
    .onTapGesture {
      action(viewState.item)
    }

  }
}

// MARK: - FollowerPage.ItemComponent.ViewState

extension FollowerPage.ItemComponent {
  struct ViewState: Equatable {
    let item: GithubEntity.User.Follower.Response
  }
}
