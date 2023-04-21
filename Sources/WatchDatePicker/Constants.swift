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

@available(macOS, unavailable)
@available(iOS, unavailable)
@available(tvOS, unavailable)
extension CGFloat {
  static var dateInputHeight: Self {
    switch WatchDeviceSize.current {
    case ._40mm, ._44mm: return 105
    default: return 110
    }
  }

  static var clockFacePadding: Self {
    switch WatchDeviceSize.current {
    case ._40mm: return -13
    case ._41mm: return -21
    case ._44mm: return -13
    case ._45mm: return -23
    case ._49mm: return -29.5
    }
  }

  static var hourAndMinuteCircularButtonsBottomPadding: Self {
    switch WatchDeviceSize.current {
    case ._40mm: return -22
    case ._41mm: return -27.5
    case ._45mm: return -28.5
    case ._49mm: return -31.5
    default: return -26
    }
  }
  
  static var hourAndMinuteCircularButtonsHorizontalPadding: Self {
    switch WatchDeviceSize.current {
    case ._40mm: return 30
    case ._41mm: return 30
    case ._45mm: return 34
    case ._49mm: return 34
    default: return 32
    }
  }

  static var componentFontSize: Self {
    switch WatchDeviceSize.current {
    case ._40mm: return 28
    case ._41mm: return 34.5
    case ._44mm: return 32
    case ._45mm: return 39
    case ._49mm: return 38
    }
  }
  
  static var selectionIndicatorRadius: Self {
    switch WatchDeviceSize.current {
    case ._45mm, ._49mm: return 2.75
    default: return 2.25
    }
  }
  
  static var pickerCornerRadius: Self {
    switch WatchDeviceSize.current {
    case ._41mm, ._45mm, ._49mm: return 15
    default: return 8.5
    }
  }

  static var pickerFontSize: Self {
    switch WatchDeviceSize.current {
    case ._40mm: return 21
    default: return 23
    }
  }

  static var pickerLabelMinimumScaleFactor: Self {
    switch WatchDeviceSize.current {
    case ._41mm, ._45mm, ._49mm: return 0.8
    default: return 1
    }
  }

  static var circularButtonDiameter: Self {
    switch WatchDeviceSize.current {
    case ._40mm: return 34
    case ._45mm: return 39.5
    case ._49mm: return 40.5
    default: return 37.5
    }
  }
  
  static var circularButtonFontSize: Self {
    switch WatchDeviceSize.current {
    case ._40mm: return 18.5
    case ._45mm: return 22.5
    case ._49mm: return 22
    default: return 20.5
    }
  }
  
  // TODO: consider using padding for this instead
  static var timePeriodButtonMinWidth: Self {
    switch WatchDeviceSize.current {
    case ._41mm: return 29.5
    case ._45mm, ._49mm: return 32.5
    default: return 24.5
    }
  }
  
  static var timePeriodButtonMaxHeight: Self {
    switch WatchDeviceSize.current {
    case ._41mm: return 19
    case ._45mm, ._49mm: return 21
    default: return 16
    }
  }
  
  static var timePeriodButtonFontSize: Self {
    switch WatchDeviceSize.current {
    case ._41mm: return 17
    case ._45mm, ._49mm: return 18
    default: return 15
    }
  }
  
  static var timePeriodButtonCornerRadius: Self {
    switch WatchDeviceSize.current {
    case ._41mm: return 4
    case ._45mm, ._49mm: return 5
    default: return 3
    }
  }
  
  static var timeComponentButtonWidth: Self {
    switch WatchDeviceSize.current {
    case ._40mm: return 39
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
    case ._49mm: return 58
    }
  }

  static var timeComponentButtonCornerRadius: Self {
    switch WatchDeviceSize.current {
    case ._40mm: return 7
    default: return 11
    }
  }

  static var twentyFourHourIndicatorOffset: Self {
    switch WatchDeviceSize.current {
    case ._40mm: return -23
    case ._41mm: return -23
    case ._44mm: return -23
    case ._45mm: return -26
    case ._49mm: return -30
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
