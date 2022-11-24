#if os(watchOS)
import SwiftUI
import WatchKit

@available(macOS, unavailable)
@available(iOS, unavailable)
@available(tvOS, unavailable)
enum WatchDeviceSize: Double {
  case _40mm = 162
  case _41mm = 176
  case _44mm = 184
  case _45mm = 198
  case _49mm = 205

  static var current: Self {
    .init(rawValue: WKInterfaceDevice.current().screenBounds.width) ?? ._45mm
  }
}

//enum WatchDeviceSize2 {
//  case _40mm, _41mm, _44mm, _45mm
//
//  static var current: Self {
//    switch WKInterfaceDevice.current().screenBounds.width {
//    case 162: return ._40mm
//    case 176: return ._41mm
//    case 184: return ._44mm
//    case 198: return ._45mm
//    default: return ._45mm
//    }
//  }
//}

@available(macOS, unavailable)
@available(iOS, unavailable)
@available(tvOS, unavailable)
extension CGFloat {
  static var selectionIndicatorRadius: Self {
    switch WatchDeviceSize.current {
    case ._45mm, ._49mm: return 2.75
    default: return 2.25
    }
  }
  
  static var pickerLabelMinimumScaleFactor: Self {
    switch WatchDeviceSize.current {
    case ._41mm, ._45mm, ._49mm: return 0.8
    default: return 1
    }
  }
  
  static var timeComponentButtonWidth: Self {
    switch WatchDeviceSize.current {
    case ._40mm: return 39
    // case ._41mm: return 40
    case ._45mm, ._49mm: return 51
    default: return 46
    }
  }

  static var timeComponentButtonHeight: Self {
    switch WatchDeviceSize.current {
    case ._40mm: return 39
    case ._41mm: return 52
    case ._44mm: return 51
    case ._45mm: return 58
    case ._49mm: return 56
    }
  }

  static var timeComponentButtonCornerRadius: Self {
    switch WatchDeviceSize.current {
    case ._40mm: return 7
    default: return 11
    }
  }
}

@available(macOS, unavailable)
@available(iOS, unavailable)
@available(tvOS, unavailable)
extension CGSize {
  static var heavyMarkSize: Self {
    switch WatchDeviceSize.current {
    case ._45mm, ._49mm: return CGSize(width: 2, height: 2.5)
    default: return CGSize(width: 1.5, height: 2.5)
    }
  }

  static var markSize: Self {
    switch WatchDeviceSize.current {
    case ._45mm, ._49mm: return CGSize(width: 1.75, height: 7.5)
    default: return CGSize(width: 1.25, height: 6.5)
    }
  }
}

@available(macOS, unavailable)
@available(iOS, unavailable)
@available(tvOS, unavailable)
extension Color {
  static let timeComponentButtonBorder = Color(white: 0.298)
}
#endif
