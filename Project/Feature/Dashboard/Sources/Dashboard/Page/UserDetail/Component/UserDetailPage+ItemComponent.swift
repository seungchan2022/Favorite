import Domain
import SwiftUI
import UIKit
import WebKit

extension UserDetailPage {
  struct WebContent {
    let viewState: ViewState
  }
}

extension UserDetailPage.WebContent: UIViewRepresentable {
  func makeUIView(context _: Context) -> some UIView {
    let webView = WKWebView(frame: .zero, configuration: .init())
    
    if let url = URL(string: viewState.item.htmlURL) {
      webView.load(.init(url: url))
    }
    return webView
  }
  
  func updateUIView(_ uiView: UIViewType, context: Context) {
  }
}

extension UserDetailPage.WebContent {
  struct ViewState: Equatable {
    let item: GithubEntity.Detail.User.Response
  }
}
