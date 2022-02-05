// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ColorAsset.Color", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetColorTypeAlias = ColorAsset.Color
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Asset {
  internal static let accentColor = ColorAsset(name: "AccentColor")
  internal static let antenna = ImageAsset(name: "antenna")
  internal static let location = ImageAsset(name: "location")
  internal static let marker = ImageAsset(name: "marker")
  internal static let message = ImageAsset(name: "message")
  internal static let search = ImageAsset(name: "search")
  internal static let sesac1 = ImageAsset(name: "sesac1")
  internal static let sesac2 = ImageAsset(name: "sesac2")
  internal static let sesac3 = ImageAsset(name: "sesac3")
  internal static let sesac4 = ImageAsset(name: "sesac4")
  internal static let sesac5 = ImageAsset(name: "sesac5")
  internal static let arrowRight = ImageAsset(name: "arrow.right")
  internal static let defaultBackground = ImageAsset(name: "defaultBackground")
  internal static let defaultSesac = ImageAsset(name: "defaultSesac")
  internal static let inquiry = ImageAsset(name: "inquiry")
  internal static let notice = ImageAsset(name: "notice")
  internal static let notification = ImageAsset(name: "notification")
  internal static let question = ImageAsset(name: "question")
  internal static let terms = ImageAsset(name: "terms")
  internal static let green = ColorAsset(name: "green")
  internal static let whiteGreen = ColorAsset(name: "whiteGreen")
  internal static let yellowGreen = ColorAsset(name: "yellowGreen")
  internal static let gray1 = ColorAsset(name: "gray1")
  internal static let gray2 = ColorAsset(name: "gray2")
  internal static let gray3 = ColorAsset(name: "gray3")
  internal static let gray4 = ColorAsset(name: "gray4")
  internal static let gray5 = ColorAsset(name: "gray5")
  internal static let gray6 = ColorAsset(name: "gray6")
  internal static let gray7 = ColorAsset(name: "gray7")
  internal static let error = ColorAsset(name: "error")
  internal static let focus = ColorAsset(name: "focus")
  internal static let success = ColorAsset(name: "success")
  internal static let black = ColorAsset(name: "black")
  internal static let transparent = ColorAsset(name: "transparent")
  internal static let white = ColorAsset(name: "white")
  internal static let home = ImageAsset(name: "home")
  internal static let mypage = ImageAsset(name: "mypage")
  internal static let sesacfriend = ImageAsset(name: "sesacfriend")
  internal static let sesacshop = ImageAsset(name: "sesacshop")
  internal static let backNarrow = ImageAsset(name: "backNarrow")
  internal static let defaultProfile = ImageAsset(name: "defaultProfile")
  internal static let man = ImageAsset(name: "man")
  internal static let manButton = ImageAsset(name: "manButton")
  internal static let onBoarding1 = ImageAsset(name: "onBoarding1")
  internal static let onBoarding2 = ImageAsset(name: "onBoarding2")
  internal static let onBoarding3 = ImageAsset(name: "onBoarding3")
  internal static let splashLogo = ImageAsset(name: "splash_logo")
  internal static let splashText = ImageAsset(name: "splash_text")
  internal static let woman = ImageAsset(name: "woman")
  internal static let womanButton = ImageAsset(name: "womanButton")
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

internal struct ImageAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Image = UIImage
  #endif

  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, macOS 10.7, *)
  internal var image: Image {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let name = NSImage.Name(self.name)
    let image = (bundle == .main) ? NSImage(named: name) : bundle.image(forResource: name)
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }

  #if os(iOS) || os(tvOS)
  @available(iOS 8.0, tvOS 9.0, *)
  internal func image(compatibleWith traitCollection: UITraitCollection) -> Image {
    let bundle = BundleToken.bundle
    guard let result = Image(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }
  #endif
}

internal extension ImageAsset.Image {
  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, *)
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init?(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = BundleToken.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

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
