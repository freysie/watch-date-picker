import SwiftUI

@available(macOS, unavailable)
@available(iOS, unavailable)
@available(tvOS, unavailable)
extension ButtonStyle where Self == TimeComponentButtonStyle {
  static func timeComponent(isFocused: Bool = false, focusColor: Color? = nil, width: CGFloat? = nil) -> Self {
    .init(isFocused: isFocused, focusColor: focusColor, width: width)
  }
}

@available(macOS, unavailable)
@available(iOS, unavailable)
@available(tvOS, unavailable)
struct TimeComponentButtonStyle: ButtonStyle {
  var isFocused: Bool
  var focusColor: Color?
  var width: CGFloat?
  
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .frame(width: width ?? 46, height: 51)
      .offset(y: 0.5)
      .overlay {
        RoundedRectangle(cornerRadius: 11)
          .strokeBorder(isFocused ? focusColor ?? .green : .timeComponentButtonBorder, lineWidth: 1.5)
      }
  }
}

@available(macOS, unavailable)
@available(iOS, unavailable)
@available(tvOS, unavailable)
extension Color {
  static let timeComponentButtonBorder = Color(white: 0.298)
}

@available(macOS, unavailable)
@available(iOS, unavailable)
@available(tvOS, unavailable)
extension ButtonStyle where Self == TimePeriodButtonStyle {
  static func timePeriod(isHighlighted: Bool = false, highlightColor: Color? = nil) -> Self {
    .init(isHighlighted: isHighlighted, highlightColor: highlightColor)
  }
}

@available(macOS, unavailable)
@available(iOS, unavailable)
@available(tvOS, unavailable)
struct TimePeriodButtonStyle: ButtonStyle {
  var isHighlighted: Bool
  var highlightColor: Color?
  @Environment(\.datePickerFocusTint) private var focusTint

  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .frame(minWidth: 24.5, maxHeight: 16)
      .font(.system(size: 15, weight: isHighlighted ? .semibold : .regular))
      .opacity(configuration.isPressed ? 0.5 : isHighlighted ? 1 : 0.8)
      .foregroundColor(isHighlighted ? .black : highlightColor ?? Color.accentColor)
      .background {
        RoundedRectangle(cornerRadius: 3)
          .fill(isHighlighted ? highlightColor ?? Color.accentColor : Color.clear)
          .offset(y: 0.5)
      }
  }
}
