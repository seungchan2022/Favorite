import SwiftUI
import Domain
import DesignSystem

extension RepoPage {
  struct RepositoryItemComponent {
    let viewState: ViewState
    let action: (GithubEntity.Search.Repository.Item) -> Void
  }
}

extension RepoPage.RepositoryItemComponent {
  private var isEmptyRankCount: Bool {
    (
      viewState.item.starCount
      + viewState.item.forkCount
      + viewState.item.watcherCount
    ) == .zero
  }
}

extension RepoPage.RepositoryItemComponent: View {
  var body: some View {
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
          .foregroundStyle(DesignSystemColor.system(.black).color)
        
        if let desc = viewState.item.desc {
          Text(desc)
            .font(.system(size: 12, weight: .bold))
            .foregroundStyle(DesignSystemColor.system(.black).color)
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
      
      Spacer()
      
    }
    .frame(minWidth: .zero, maxWidth: .infinity)
    .padding(16)
    .onTapGesture {
      action(viewState.item)
    }
  }
}

extension RepoPage.RepositoryItemComponent {
  struct ViewState: Equatable {
    let item: GithubEntity.Search.Repository.Item
  }
}
