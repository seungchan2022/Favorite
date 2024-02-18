import SwiftUI
import Domain
import UIKit
import WebKit

extension RepoDetailPage {
  struct WebContent {
    let viewState: ViewState
  }
}

extension RepoDetailPage.WebContent: UIViewRepresentable {
  func makeUIView(context: Context) -> some UIView {
    let webView = WKWebView(frame: .zero, configuration: .init())
    
    if let url = URL(string: viewState.item.htmlURL) {
      webView.load(.init(url: url))
    }
    return webView
  }
  
  func updateUIView(_ uiView: UIViewType, context: Context) {
  }
}

extension RepoDetailPage.WebContent {
  struct ViewState: Equatable {
    let item: GithubEntity.Detail.Repository.Response
  }
}
