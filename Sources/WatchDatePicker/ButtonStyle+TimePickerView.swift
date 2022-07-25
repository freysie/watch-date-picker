import SwiftUI

@available(macOS, unavailable)
@available(iOS, unavailable)
@available(tvOS, unavailable)
extension ButtonStyle where Self == TimePickerComponentButtonStyle {
  static func timePickerComponent(isFocused: Bool = false, focusColor: Color? = nil, width: CGFloat? = nil) -> Self {
    .init(isFocused: isFocused, focusColor: focusColor, width: width)
  }
}

@available(macOS, unavailable)
@available(iOS, unavailable)
@available(tvOS, unavailable)
struct TimePickerComponentButtonStyle: ButtonStyle {
  var isFocused: Bool
  var focusColor: Color?
  var width: CGFloat?
  
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .frame(width: width ?? 46, height: 51)
      .offset(y: 0.5)
      .overlay {
        RoundedRectangle(cornerRadius: 11)
          .strokeBorder(isFocused ? focusColor ?? .green : .timePickerComponentButtonBorder, lineWidth: 1.5)
      }
  }
}

@available(macOS, unavailable)
@available(iOS, unavailable)
@available(tvOS, unavailable)
extension Color {
  static let timePickerComponentButtonBorder = Color(white: 0.298)
}

@available(macOS, unavailable)
@available(iOS, unavailable)
@available(tvOS, unavailable)
extension ButtonStyle where Self == TimePickerAMPMButtonStyle {
  static func timePickerAMPM(isHighlighted: Bool = false, highlightColor: Color? = nil) -> Self {
    .init(isHighlighted: isHighlighted, highlightColor: highlightColor)
  }
}

@available(macOS, unavailable)
@available(iOS, unavailable)
@available(tvOS, unavailable)
struct TimePickerAMPMButtonStyle: ButtonStyle {
  var isHighlighted: Bool
  var highlightColor: Color?

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

@available(macOS, unavailable)
@available(iOS, unavailable)
@available(tvOS, unavailable)
extension ButtonStyle where Self == CircularButtonStyle {
  static func circular(_ color: Color = .buttonBackground) -> Self { .init(color: color) }
}

@available(macOS, unavailable)
@available(iOS, unavailable)
@available(tvOS, unavailable)
struct CircularButtonStyle: ButtonStyle {
  var color: Color

  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .font(.system(size: 20.5, weight: .bold, design: .rounded))
      .frame(width: 37.5, height: 37.5)
      .scaleEffect(configuration.isPressed ? 0.9 : 1)
      .foregroundColor(color == .buttonBackground || color == .gray ? .primary : color)
      .background {
        Circle()
          .fill(color.opacity(color == .buttonBackground ? 1 : color == .gray ? 0.38 : 0.3))
      }
  }
}

@available(macOS, unavailable)
@available(iOS, unavailable)
@available(tvOS, unavailable)
extension Color {
  static let buttonBackground = Color(white: 0.103)
}
