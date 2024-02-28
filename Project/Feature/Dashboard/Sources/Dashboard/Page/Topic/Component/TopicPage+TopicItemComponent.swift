import DesignSystem
import Domain
import SwiftUI

extension TopicPage {
  struct TopicItemComponent {
    let viewState: ViewState
  }
}

extension TopicPage.TopicItemComponent {
  
}

extension TopicPage.TopicItemComponent: View {
  var body: some View {
    VStack(alignment:.leading, spacing: 8) {
        Text(viewState.item.displayName ?? viewState.item.name)
      
      if let shortDec = viewState.item.shortDescription {
        Text(shortDec)
      }
    }
    .padding(8)
    .frame(minWidth: .zero, maxWidth: .infinity, alignment: .leading)
    .background(
      RoundedRectangle(cornerRadius: 5)
        .stroke(lineWidth: 1)
    )
    .padding(16)
  }
}

extension TopicPage.TopicItemComponent {
  struct ViewState: Equatable {
    let item: GithubEntity.Search.Topic.Item
  }
}
