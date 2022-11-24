#if os(watchOS)
import SwiftUI

private let SUGGESTED_HEIGHT: CGFloat = 51.0

@available(macOS, unavailable)
@available(iOS, unavailable)
@available(tvOS, unavailable)
extension ButtonStyle where Self == TimeComponentButtonStyle {
  static func timeComponent(isFocused: Bool = false) -> Self {
    .init(isFocused: isFocused)
  }
}

@available(macOS, unavailable)
@available(iOS, unavailable)
@available(tvOS, unavailable)
struct TimeComponentButtonStyle: ButtonStyle {
  @State private var padding: CGFloat = 0.0
  
  var isFocused: Bool

  @Environment(\.timeInputViewFocusTint) private var focusTint
  @Environment(\.timeInputViewMonospacedDigit) private var useMonospacedFont

  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .frame(width: usableWidth)
      .padding(.vertical, padding)
      .offset(y: 0.5)
      .readSize(onChange: { size in
        guard padding == 0.0 else {
          return
        }
        
        padding = ceil((SUGGESTED_HEIGHT - size.height) * 0.5)
      })
      .overlay {
        RoundedRectangle(cornerRadius: 8)
          .strokeBorder(isFocused ? focusTint ?? .green : .timeComponentButtonBorder, lineWidth: 1.5)
      }
  }
  
  private var usableWidth: CGFloat {
    get {
      (fontPointSize() * 2.0) - 16.0
    }
  }
  
  private func fontPointSize() -> CGFloat {
    let baseFont = UIFont.preferredFont(forTextStyle: .title2)
    
    guard useMonospacedFont ?? true else {
      return baseFont.pointSize
    }
    
    let monospacedDigitFont = UIFont.monospacedDigitSystemFont(ofSize: baseFont.pointSize, weight: isFocused ? .semibold : .regular)
    return CGFloat(monospacedDigitFont.pointSize)
  }
}

@available(macOS, unavailable)
@available(iOS, unavailable)
@available(tvOS, unavailable)
extension ButtonStyle where Self == TimePeriodButtonStyle {
  static func timePeriod(isHighlighted: Bool = false) -> Self {
    .init(isHighlighted: isHighlighted)
  }
}

@available(macOS, unavailable)
@available(iOS, unavailable)
@available(tvOS, unavailable)
struct TimePeriodButtonStyle: ButtonStyle {
  var isHighlighted: Bool

  @Environment(\.timeInputViewAMPMHighlightTint) private var highlightTint
  
  func makeBody(configuration: Configuration) -> some View {
    let tint = highlightTint.map { AnyShapeStyle($0) } ?? AnyShapeStyle(.tint)
    return configuration.label
      .padding(.horizontal, 4)
      .font(isHighlighted ? .body.bold() : .body)
      .opacity(configuration.isPressed ? 0.5 : isHighlighted ? 1 : 0.8)
      .foregroundStyle(isHighlighted ? AnyShapeStyle(.black) : tint)
      .background {
        RoundedRectangle(cornerRadius: 4)
          .fill(isHighlighted ? tint : AnyShapeStyle(.clear))
          .offset(y: 0.5)
      }
  }
}
#endif
