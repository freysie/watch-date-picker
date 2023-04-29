#if os(watchOS)

import SwiftUI

extension ButtonStyle where Self == TimeComponentButtonStyle {
  static func timeComponent(isFocused: Bool = false) -> Self {
    .init(isFocused: isFocused)
  }
}

struct TimeComponentButtonStyle: ButtonStyle {
  var isFocused: Bool

  @Environment(\.timeInputViewComponentBorderColor) private var borderColor
  @Environment(\.timeInputViewFocusTint) private var focusTint

  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .frame(width: .timeComponentButtonWidth, height: .timeComponentButtonHeight)
      .offset(y: 0.5)
      .overlay {
        RoundedRectangle(cornerRadius: .timeComponentButtonCornerRadius)
          .strokeBorder(
            isFocused ? focusTint ?? .green : borderColor ?? .timeComponentButtonBorder,
            lineWidth: 1.5
          )
      }
  }
}

extension ButtonStyle where Self == TimePeriodButtonStyle {
  static func timePeriod(isHighlighted: Bool = false) -> Self {
    .init(isHighlighted: isHighlighted)
  }
}

struct TimePeriodButtonStyle: ButtonStyle {
  var isHighlighted: Bool

  @Environment(\.locale) private var locale
  @Environment(\.timeInputViewAMPMHighlightTint) private var highlightTint

  func makeBody(configuration: Configuration) -> some View {
    let tint = highlightTint.map { AnyShapeStyle($0) } ?? AnyShapeStyle(.tint)
    return configuration.label
      .frame(minWidth: .timePeriodButtonMinWidth, maxHeight: .timePeriodButtonMaxHeight)
      .font(.system(size: .timePeriodButtonFontSize, weight: isHighlighted ? .semibold : .regular))
      .opacity(configuration.isPressed ? 0.5 : isHighlighted ? 1 : 0.8)
      .foregroundStyle(isHighlighted ? AnyShapeStyle(.black) : tint)
      .offset(y: ["ar", "hi"].contains(locale.identifier) ? -3 : 0)
      .background {
        RoundedRectangle(cornerRadius: .timePeriodButtonCornerRadius)
          .fill(isHighlighted ? tint : AnyShapeStyle(.black))
          .offset(y: 0.5)
      }
  }
}

#endif
