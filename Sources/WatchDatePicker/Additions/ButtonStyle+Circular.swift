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

  private var diameter: Double {
    switch WKInterfaceDevice.current().screenBounds.width {
    case 162: return 33.5 // 40 mm
    // case 176: return 35 // 41 mm
    case 198: return 41.5 // 45 mm
    default: return 37.5
    }
  }

  private var fontSize: Double {
    switch WKInterfaceDevice.current().screenBounds.width {
    case 162: return 16.5 // 40 mm
    // case 176: return 35 // 41 mm
    case 198: return 22.5 // 45 mm
    default: return 20.5
    }
  }

  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .font(.system(size: fontSize, weight: .bold, design: .rounded))
      .frame(width: diameter, height: diameter)
      .foregroundColor(color == .gray ? .primary : color)
      .background { Circle().fill(color.opacity(color == .gray ? 0.38 : 0.3)) }
      .scaleEffect(configuration.isPressed ? 0.9 : 1)
      .opacity(configuration.isPressed ? 0.5 : 1)
  }
}
