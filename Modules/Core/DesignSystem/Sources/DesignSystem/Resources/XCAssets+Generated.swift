// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif
#if canImport(SwiftUI)
  import SwiftUI
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ColorAsset.Color", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetColorTypeAlias = ColorAsset.Color

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Asset {
  internal enum ColorChip {
    internal enum Background {
      internal static let backgroundBlue = ColorAsset(name: "BackgroundBlue")
      internal static let backgroundGreen = ColorAsset(name: "BackgroundGreen")
    }
    internal enum Error {
      internal static let errorDefault = ColorAsset(name: "ErrorDefault")
    }
    internal enum Label {
      internal static let labelDefault = ColorAsset(name: "LabelDefault")
    }
    internal enum Overlay {
      internal static let overlayDefault = ColorAsset(name: "OverlayDefault")
    }
    internal enum Palette {
      internal enum Gray {
        internal static let paletteGray100 = ColorAsset(name: "PaletteGray100")
        internal static let paletteGray200 = ColorAsset(name: "PaletteGray200")
        internal static let paletteGray250 = ColorAsset(name: "PaletteGray250")
        internal static let paletteGray300 = ColorAsset(name: "PaletteGray300")
        internal static let paletteGray400 = ColorAsset(name: "PaletteGray400")
      }
    }
    internal enum System {
      internal static let systemBlack = ColorAsset(name: "SystemBlack")
      internal static let systemWhite = ColorAsset(name: "SystemWhite")
    }
    internal enum Tint {
      internal static let tintGreen = ColorAsset(name: "TintGreen")
      internal static let tintPurple = ColorAsset(name: "TintPurple")
      internal static let tintRed = ColorAsset(name: "TintRed")
      internal static let tintSand = ColorAsset(name: "TintSand")
    }
  }
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal final class ColorAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Color = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Color = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  internal private(set) lazy var color: Color = {
    guard let color = Color(asset: self) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }()

  #if os(iOS) || os(tvOS)
  @available(iOS 11.0, tvOS 11.0, *)
  internal func color(compatibleWith traitCollection: UITraitCollection) -> Color {
    let bundle = BundleToken.bundle
    guard let color = Color(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }
  #endif

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  internal private(set) lazy var swiftUIColor: SwiftUI.Color = {
    SwiftUI.Color(asset: self)
  }()
  #endif

  fileprivate init(name: String) {
    self.name = name
  }
}

internal extension ColorAsset.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init?(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
internal extension SwiftUI.Color {
  init(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle)
  }
}
#endif

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
