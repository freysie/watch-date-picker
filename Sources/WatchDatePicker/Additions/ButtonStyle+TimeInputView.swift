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

  private var width: Double {
    switch WKInterfaceDevice.current().screenBounds.width {
    case 162: return 39 // 40 mm
    // case 176: return 40 // 41 mm
    case 198: return 51 // 45 mm
    default: return 46
    }
  }

  private var height: Double {
    switch WKInterfaceDevice.current().screenBounds.width {
    case 162: return 39 // 40 mm
    case 176: return 52 // 41 mm
    case 198: return 58 // 45 mm
    default: return 51
    }
  }

  private var cornerRadius: Double {
    switch WKInterfaceDevice.current().screenBounds.width {
    case 162: return 7 // 40 mm
    default: return 11
    }
  }

  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .frame(width: width, height: height)
      .offset(y: 0.5)
      .overlay {
        RoundedRectangle(cornerRadius: cornerRadius)
          .strokeBorder(isFocused ? focusTint ?? .green : .timeComponentButtonBorder, lineWidth: 1.5)
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
  static func timePeriod(isHighlighted: Bool = false) -> Self {
    .init(isHighlighted: isHighlighted)
  }
}

enum WatchScreenSize {
  case _40mm, _41mm, _44mm, _45mm
}

@available(macOS, unavailable)
@available(iOS, unavailable)
@available(tvOS, unavailable)
struct TimePeriodButtonStyle: ButtonStyle {
  var isHighlighted: Bool

  @Environment(\.timeInputViewAMPMHighlightTint) private var highlightTint

  // TODO: consider using padding for this instead
  private var minWidth: Double {
    switch WKInterfaceDevice.current().screenBounds.width {
    case 176: return 29.5 // 41 mm
    case 198: return 32.5 // 45 mm
    default: return 24.5
    }
  }

  private var maxHeight: Double {
    switch WKInterfaceDevice.current().screenBounds.width {
    case 176: return 19 // 41 mm
    case 198: return 21 // 45 mm
    default: return 16
    }
  }
  
  private var fontSize: Double {
    switch WKInterfaceDevice.current().screenBounds.width {
    case 176: return 17 // 41 mm
    case 198: return 19 // 45 mm
    default: return 15
    }
  }
  
  private var cornerRadius: Double {
    switch WKInterfaceDevice.current().screenBounds.width {
    case 176: return 4 // 41 mm
    case 198: return 5 // 45 mm
    default: return 3
    }
  }
  
  func makeBody(configuration: Configuration) -> some View {
    let tint = highlightTint.map { AnyShapeStyle($0) } ?? AnyShapeStyle(.tint)
    return configuration.label
      .frame(minWidth: minWidth, maxHeight: maxHeight)
      .font(.system(size: fontSize, weight: isHighlighted ? .semibold : .regular))
      .opacity(configuration.isPressed ? 0.5 : isHighlighted ? 1 : 0.8)
      .foregroundStyle(isHighlighted ? AnyShapeStyle(.black) : tint)
      .background {
        RoundedRectangle(cornerRadius: cornerRadius)
          .fill(isHighlighted ? tint : AnyShapeStyle(.clear))
          .offset(y: 0.5)
      }
  }
}
