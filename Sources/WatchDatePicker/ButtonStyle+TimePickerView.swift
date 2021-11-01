import SwiftUI

internal extension ButtonStyle where Self == TimePickerComponentButtonStyle {
  static func timePickerComponent(isFocused: Bool = false, focusColor: Color? = nil, width: CGFloat? = nil) -> Self {
    .init(isFocused: isFocused, focusColor: focusColor, width: width)
  }
}

internal struct TimePickerComponentButtonStyle: ButtonStyle {
  var isFocused: Bool
  var focusColor: Color?
  var width: CGFloat?
  
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .frame(width: width ?? 43, height: 48)
      .overlay {
        RoundedRectangle(cornerRadius: 9)
          .stroke(isFocused ? focusColor ?? .green : .timePickerComponentButtonBorder, lineWidth: 1.5)
      }
  }
}

internal extension Color {
  static var timePickerComponentButtonBorder: Self { Color(white: 0.298) }
}

internal extension ButtonStyle where Self == TimePickerAMPMButtonStyle {
  static func timePickerAMPM(isHighlighted: Bool = false, highlightColor: Color? = nil) -> Self {
    .init(isHighlighted: isHighlighted, highlightColor: highlightColor)
  }
}

internal struct TimePickerAMPMButtonStyle: ButtonStyle {
  var isHighlighted: Bool
  var highlightColor: Color?

  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .frame(minWidth: 24.5, idealHeight: 16)
      .opacity(configuration.isPressed ? 0.5 : isHighlighted ? 1 : 0.8)
      .font(.footnote.weight(isHighlighted ? .semibold : .regular))
      .foregroundColor(isHighlighted ? .black : highlightColor ?? Color.accentColor)
      .background {
        RoundedRectangle(cornerRadius: 3)
          .fill(isHighlighted ? highlightColor ?? Color.accentColor : Color.clear)
      }
  }
}
