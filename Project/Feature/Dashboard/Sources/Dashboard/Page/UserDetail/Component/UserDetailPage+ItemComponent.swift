import DesignSystem
import Domain
import SwiftUI

// MARK: - UserDetailPage.ItemComponent

extension UserDetailPage {
  struct ItemComponent {
    let viewState: ViewState
    let followerAction: (GithubEntity.Detail.User.Response) -> Void
    @Environment(\.colorScheme) var colorScheme
  }
}

extension UserDetailPage.ItemComponent {
  var createdDate: String {
    viewState.item.created.toDate?.toString ?? "N/A"
  }
}

// MARK: - UserDetailPage.ItemComponent + View

extension UserDetailPage.ItemComponent: View {
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      HStack(spacing: 8) {
        RemoteImage(
          url: viewState.item.avatarUrl,
          placeholder: {
            Rectangle().fill(DesignSystemColor.palette(.gray(.lv100)).color)
          })
          .frame(width: 80, height: 80)
          .clipShape(RoundedRectangle(cornerRadius: 10))

        VStack(alignment: .leading, spacing: 4) {
          Text(viewState.item.loginName)
            .font(.system(size: 24, weight: .bold))
            .foregroundStyle(
              colorScheme == .dark
                ? DesignSystemColor.system(.white).color
                : DesignSystemColor.system(.black).color)

          // if/else를 해주지 않으면 해당 아이템이 없을때 위 loginName이 아래로 내려옴 (아이템이 없어도 항상 같은자리에 있기르 원함)
          if let name = viewState.item.name {
            Text(name)
              .font(.system(size: 16))
              .foregroundStyle(DesignSystemColor.palette(.gray(.lv300)).color)
          } else {
            Text("")
              .font(.system(size: 16))
          }

          HStack {
            if let location = viewState.item.location {
              Image(systemName: "mappin.and.ellipse")
                .resizable()
                .frame(width: 12, height: 12)
                .foregroundStyle(DesignSystemColor.tint(.purple).color)

              Text(location)
                .font(.system(size: 16))
                .foregroundStyle(DesignSystemColor.palette(.gray(.lv300)).color)
            } else {
              Text("")
                .font(.system(size: 16))
            }
          }
        }
      }

      Text(viewState.item.bio ?? "")
        .font(.system(size: 16))
        .foregroundStyle(DesignSystemColor.palette(.gray(.lv300)).color)
        .padding(.vertical, 16)

      GroupBox {
        VStack {
          HStack {
            VStack {
              HStack(spacing: 8) {
                Image(systemName: "folder")
                  .resizable()
                  .frame(width: 14, height: 14)

                Text("Public repos")
                  .font(.system(size: 16))
              }

              Text("\(viewState.item.repoListCount)")
                .font(.system(size: 16))
            }

            Spacer()

            VStack {
              HStack(spacing: 8) {
                Image(systemName: "line.3.horizontal")
                  .resizable()
                  .frame(width: 14, height: 14)

                Text("Public gists")
                  .font(.system(size: 16))
              }

              Text("\(viewState.item.gistListCount)")
                .font(.system(size: 16))
            }
          }
          .foregroundStyle(colorScheme == .dark ? DesignSystemColor.system(.white).color : DesignSystemColor.system(.black).color)
          .padding(.horizontal, 16)

          Button(action: { }) {
            Text("Github Profile")
              .font(.headline)
              .frame(width: 280)
          }
          .tint(DesignSystemColor.tint(.purple).color)
          .buttonStyle(.bordered)
          .controlSize(.large)
        }
      }
      .padding(.bottom, 12)
      .frame(maxWidth: .infinity)

      GroupBox {
        VStack {
          HStack {
            VStack {
              HStack(spacing: 8) {
                Image(systemName: "heart")
                  .resizable()
                  .frame(width: 14, height: 14)

                Text("Followers")
                  .font(.system(size: 16))
              }

              Text("\(viewState.item.followerListCount)")
                .font(.system(size: 16))
            }

            Spacer()

            VStack {
              HStack(spacing: 8) {
                Image(systemName: "person.2")
                  .resizable()
                  .frame(width: 14, height: 14)

                Text("Following")
                  .font(.system(size: 16))
              }

              Text("\(viewState.item.followingListCount)")
                .font(.system(size: 16))
            }
          }
          .foregroundStyle(colorScheme == .dark ? DesignSystemColor.system(.white).color : DesignSystemColor.system(.black).color)
          .padding(.horizontal, 16)

          Button(action: { followerAction(viewState.item) }) {
            Text("Get Followers")
              .font(.headline)
              .frame(width: 280)
          }
          .tint(DesignSystemColor.tint(.green).color)
          .buttonStyle(.bordered)
          .controlSize(.large)
        }
      }
      .padding(.bottom, 12)
      .frame(maxWidth: .infinity)

      Text("Github since \(createdDate)")
        .frame(maxWidth: .infinity, alignment: .center) // 추가

      Spacer()
    }
    .padding(.horizontal, 16)
    .frame(minWidth: .zero, maxWidth: .infinity, alignment: .leading)
  }
}

// MARK: - UserDetailPage.ItemComponent.ViewState

extension UserDetailPage.ItemComponent {
  struct ViewState: Equatable {
    let item: GithubEntity.Detail.User.Response
  }
}

extension String {
  fileprivate var toDate: Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    return dateFormatter.date(from: self)
  }
}

extension Date {
  fileprivate var toString: String? {
    let displayFormatter = DateFormatter()
    displayFormatter.dateFormat = "MMM yyyy"
    return displayFormatter.string(from: self)
  }
}
