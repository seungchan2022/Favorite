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
    VStack(spacing: 16) {
      if let displayName = viewState.item.displayName {
        Text(displayName)
          .font(.system(size: 48, weight: .bold))
      }
      
      if let description = viewState.item.description {
        Text(description)
      }
    }
    .padding(16)
    .frame(minWidth: .zero, maxWidth: .infinity)
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
