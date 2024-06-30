import Domain
import SwiftUI
import UIKit
import WebKit

// MARK: - ProfilePage.WebContent

extension ProfilePage {
  struct WebContent {
    let viewState: ViewState
  }
}

// MARK: - ProfilePage.WebContent + UIViewRepresentable

extension ProfilePage.WebContent: UIViewRepresentable {
  func makeUIView(context _: Context) -> some UIView {
    let webView = WKWebView(frame: .zero, configuration: .init())

    if let url = URL(string: viewState.item.htmlURL ?? "") {
      webView.load(.init(url: url))
    }
    return webView
  }

  func updateUIView(_: UIViewType, context _: Context) { }
}

// MARK: - ProfilePage.WebContent.ViewState

extension ProfilePage.WebContent {
  struct ViewState: Equatable {
    let item: GithubEntity.Detail.User.Response
  }
}
