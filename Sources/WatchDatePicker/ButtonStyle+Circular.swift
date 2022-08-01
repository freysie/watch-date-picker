import SwiftUI

@available(macOS, unavailable)
@available(iOS, unavailable)
@available(tvOS, unavailable)
extension ButtonStyle where Self == CircularButtonStyle {
  static func circular(_ color: Color) -> Self { .init(color: color) }
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
      .foregroundColor(color == .gray ? .primary : color)
      .background { Circle().fill(color.opacity(color == .gray ? 0.38 : 0.3)) }
      .scaleEffect(configuration.isPressed ? 0.9 : 1)
      .opacity(configuration.isPressed ? 0.5 : 1)
  }
}
