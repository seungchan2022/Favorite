import DesignSystem
import Domain
import Functor
import SwiftUI

// MARK: - LikePage.UserItemComponent

extension LikePage {
  struct UserItemComponent {
    let viewState: ViewState
    let action: (GithubEntity.Detail.User.Response) -> Void
    @Environment(\.colorScheme) var colorScheme
  }
}

extension LikePage.UserItemComponent {
  private var isEmptyRankCount: Bool {
    (
      viewState.item.repoListCount
        + viewState.item.gistListCount
        + viewState.item.followerListCount
        + viewState.item.followingListCount) == .zero
  }

  private var formattedTime: String {
    TimeDiffFunctor.diffTime(updateTime: viewState.item.lastUpdate)
  }
}

// MARK: - LikePage.UserItemComponent + View

extension LikePage.UserItemComponent: View {
  var body: some View {
    VStack {
      HStack(alignment: .top, spacing: 8) {
        RemoteImage(
          url: viewState.item.avatarUrl,
          placeholder: {
            Rectangle()
              .fill(DesignSystemColor.palette(.gray(.lv100)).color)
          })
          .frame(width: 50, height: 50)
          .clipShape(Circle())

        VStack(alignment: .leading, spacing: 4) {
          Text(viewState.item.loginName)
            .font(.system(size: 14, weight: .bold))

          if let bio = viewState.item.bio {
            Text(bio)
              .font(.system(size: 12, weight: .bold))
          } else {
            Text("")
              .font(.system(size: 12, weight: .bold))
          }

          if !isEmptyRankCount {
            HStack {
              if viewState.item.repoListCount > .zero {
                HStack(spacing: 4) {
                  Image(systemName: "folder")
                    .resizable()
                    .frame(width: 8, height: 8)

                  Text("\(viewState.item.repoListCount)")
                    .font(.system(size: 8))
                }
              }

              if viewState.item.gistListCount > .zero {
                HStack(spacing: 4) {
                  Image(systemName: "line.3.horizontal")
                    .resizable()
                    .frame(width: 8, height: 8)

                  Text("\(viewState.item.gistListCount)")
                    .font(.system(size: 8))
                }
              }

              if viewState.item.followerListCount > .zero {
                HStack(spacing: 4) {
                  Image(systemName: "heart")
                    .resizable()
                    .frame(width: 8, height: 8)

                  Text("\(viewState.item.followerListCount)")
                    .font(.system(size: 8))
                }
              }

              if viewState.item.followingListCount > .zero {
                HStack(spacing: 4) {
                  Image(systemName: "person.2")
                    .resizable()
                    .frame(width: 8, height: 8)

                  Text("\(viewState.item.followingListCount)")
                    .font(.system(size: 8))
                }
              }
            }
          }
        }
        .foregroundStyle(colorScheme == .dark ? DesignSystemColor.system(.white).color : DesignSystemColor.system(.black).color)

        Spacer()

        Text(formattedTime)
          .font(.system(size: 14))
          .foregroundStyle(colorScheme == .dark ? DesignSystemColor.system(.white).color : DesignSystemColor.system(.black).color)
      }
    }
    .frame(minWidth: .zero, maxWidth: .infinity)
    .padding(16)
    .onTapGesture {
      action(viewState.item)
    }
  }
}

// MARK: - LikePage.UserItemComponent.ViewState

extension LikePage.UserItemComponent {
  struct ViewState: Equatable {
    let item: GithubEntity.Detail.User.Response
  }
}
