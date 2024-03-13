import SwiftUI
import Domain
import DesignSystem

extension FollowerPage {
  struct ItemComponent {
    let viewState: ViewState
    
    @Environment(\.colorScheme) var colorScheme
  }
}

extension FollowerPage.ItemComponent { }

extension FollowerPage.ItemComponent: View {
  var body: some View {
    VStack(alignment: .leading) {
      HStack(alignment: .top, spacing: 16) {
        RemoteImage(
          url: viewState.item.avatarUrl,
          placeholder: {
            Rectangle()
              .fill(DesignSystemColor.palette(.gray(.lv100)).color)
          })
          .frame(width: 50, height: 50)
          .clipShape(RoundedRectangle(cornerRadius: 10))

        Text(viewState.item.login)
          .font(.system(size: 20))
          .foregroundStyle(colorScheme == .dark ? DesignSystemColor.system(.white).color : DesignSystemColor.system(.black).color)
      }

      Divider()
    }
    .frame(maxWidth: .infinity)
    .padding(8)
    .onTapGesture {
      
    }
  }
}

extension FollowerPage.ItemComponent {
  struct ViewState: Equatable {
    let item: GithubEntity.User.Follower.Response
  }
}
