#if os(watchOS)
import SwiftUI

private let SUGGESTED_SIZE: CGFloat = 32.0

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
  @State private var padding: CGFloat = 0.0
  var color: Color

  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .font(.title3.bold())
      .padding(padding)
      //.frame(width: .circularButtonDiameter, height: .circularButtonDiameter)
      .foregroundColor(color == .gray ? .primary : color)
      .background { Circle().fill(color.opacity(color == .gray ? 0.38 : 0.3)) }
      .scaleEffect(configuration.isPressed ? 0.9 : 1)
      .opacity(configuration.isPressed ? 0.5 : 1)
      .readSize { size in
        guard padding == 0.0 else {
          return
        }
        
        padding = ceil((SUGGESTED_SIZE - min(size.width, SUGGESTED_SIZE)) * 0.5)
      }
  }
}
#endif
