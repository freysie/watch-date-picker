import SwiftUI

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
  var isFocused: Bool

  @Environment(\.timeInputViewFocusTint) private var focusTint

  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .frame(width: .timeComponentButtonWidth, height: .timeComponentButtonHeight)
      .offset(y: 0.5)
      .overlay {
        RoundedRectangle(cornerRadius: .timeComponentButtonCornerRadius)
          .strokeBorder(isFocused ? focusTint ?? .green : .timeComponentButtonBorder, lineWidth: 1.5)
      }
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
      .frame(minWidth: .timePeriodButtonMinWidth, maxHeight: .timePeriodButtonMaxHeight)
      .font(.system(size: .timePeriodButtonFontSize, weight: isHighlighted ? .semibold : .regular))
      .opacity(configuration.isPressed ? 0.5 : isHighlighted ? 1 : 0.8)
      .foregroundStyle(isHighlighted ? AnyShapeStyle(.black) : tint)
      .background {
        RoundedRectangle(cornerRadius: .timePeriodButtonCornerRadius)
          .fill(isHighlighted ? tint : AnyShapeStyle(.clear))
          .offset(y: 0.5)
      }
  }
}
