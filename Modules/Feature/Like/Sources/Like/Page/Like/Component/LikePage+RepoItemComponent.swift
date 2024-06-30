import DesignSystem
import Domain
import Functor
import SwiftUI

// MARK: - LikePage.RepoItemComponent

extension LikePage {
  struct RepoItemComponent {
    let viewState: ViewState
    let action: (GithubEntity.Detail.Repository.Response) -> Void

    @Environment(\.colorScheme) var colorScheme
  }
}

extension LikePage.RepoItemComponent {
  private var isEmptyRankCount: Bool {
    (
      viewState.item.starCount
        + viewState.item.forkCount
        + viewState.item.watcherCount) == .zero
  }

  private var formattedTime: String {
    TimeDiffFunctor.diffTime(updateTime: viewState.item.lastUpdate)
  }
}

// MARK: - LikePage.RepoItemComponent + View

extension LikePage.RepoItemComponent: View {
  var body: some View {
    VStack {
      HStack(alignment: .top, spacing: 8) {
        RemoteImage(
          url: viewState.item.owner.avatarUrl,
          placeholder: {
            Rectangle()
              .fill(DesignSystemColor.palette(.gray(.lv100)).color)
          })
          .frame(width: 30, height: 30)
          .clipShape(Circle())

        VStack(alignment: .leading, spacing: 4) {
          Text(viewState.item.fullName)
            .font(.system(size: 14, weight: .bold))

          if let desc = viewState.item.desc {
            Text(desc)
              .font(.system(size: 12, weight: .bold))
          }

          if !isEmptyRankCount {
            HStack {
              if viewState.item.starCount > .zero {
                HStack(spacing: 4) {
                  Image(systemName: "star")
                    .resizable()
                    .frame(width: 8, height: 8)

                  Text("\(viewState.item.starCount)")
                    .font(.system(size: 8))
                }
              }

              if viewState.item.watcherCount > .zero {
                HStack(spacing: 4) {
                  Image(systemName: "eye")
                    .resizable()
                    .frame(width: 8, height: 8)

                  Text("\(viewState.item.watcherCount)")
                    .font(.system(size: 8))
                }
              }

              if viewState.item.forkCount > .zero {
                HStack(spacing: 4) {
                  Image(systemName: "tuningfork")
                    .resizable()
                    .frame(width: 8, height: 8)

                  Text("\(viewState.item.forkCount)")
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

      if !viewState.item.topicList.isEmpty {
        HStack {
          TagLayout(alignment: .leading, spacing: 10) {
            ForEach(viewState.item.topicList, id: \.self) { item in
              Button(action: { }) {
                Text(item)
                  .font(.system(size: 12))
                  .foregroundStyle(DesignSystemColor.label(.default).color)
              }
            }
            .frame(height: 12)
            .padding(6)
            .background(
              Capsule()
                .fill(DesignSystemColor.background(.blue).color))
          }
        }
      }
    }
    .frame(minWidth: .zero, maxWidth: .infinity)
    .padding(16)
    .onTapGesture {
      action(viewState.item)
    }
  }
}

// MARK: - LikePage.RepoItemComponent.ViewState

extension LikePage.RepoItemComponent {
  struct ViewState: Equatable {
    let item: GithubEntity.Detail.Repository.Response
  }
}
