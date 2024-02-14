import SwiftUI
import DesignSystem
import Domain

extension UserPage {
  struct UserItemComponent {
    let viewState: ViewState
    let action: (GithubEntity.Search.User.Item) -> Void
  }
}


extension UserPage.UserItemComponent {
  
}


extension UserPage.UserItemComponent: View {
  var body: some View {
    VStack(spacing: 8) {
      RemoteImage(
        url: viewState.item.avatarUrl,
        placeholder: {
          Rectangle()
            .fill(DesignSystemColor.palette(.gray(.lv100)).color)
        })
      .frame(width: 50, height: 50)
      .clipShape(RoundedRectangle(cornerRadius: 10))
      
      Text(viewState.item.loginName)
        .font(.system(size: 14, weight: .bold))
        .foregroundStyle(DesignSystemColor.system(.black).color)
    }
    .onTapGesture {
      action(viewState.item)
    }
  }
  
}


extension UserPage.UserItemComponent {
  struct ViewState: Equatable {
    let item: GithubEntity.Search.User.Item
  }
  
}
