import DesignSystem
import Domain
import SwiftUI

// MARK: - TopicPage.TopicItemComponent

extension TopicPage {
  struct TopicItemComponent {
    let viewState: ViewState
    let action: (GithubEntity.Search.Topic.Item) -> Void
  }
}

extension TopicPage.TopicItemComponent { }

// MARK: - TopicPage.TopicItemComponent + View

extension TopicPage.TopicItemComponent: View {
  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      Button(action: { action(viewState.item) }) {
        Text(viewState.item.displayName ?? viewState.item.name)
      }

      if let shortDec = viewState.item.shortDescription {
        Text(shortDec)
      }
    }
    .padding(8)
    .frame(minWidth: .zero, maxWidth: .infinity, alignment: .leading)
    .background(
      RoundedRectangle(cornerRadius: 5)
        .stroke(lineWidth: 1))
    .padding(16)
  }
}

// MARK: - TopicPage.TopicItemComponent.ViewState

extension TopicPage.TopicItemComponent {
  struct ViewState: Equatable {
    let item: GithubEntity.Search.Topic.Item
  }
}
