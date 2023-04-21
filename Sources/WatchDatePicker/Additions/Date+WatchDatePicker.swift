#if os(watchOS)

import Foundation

extension Date {
  /// Gets the next hour from now. E.g. turns 9:41 am into 10:00 am.
  static var nextHour: Self {
    var date = Calendar.current.date(byAdding: .hour, value: 1, to: .now)!
    date = Calendar.current.date(bySetting: .minute, value: 0, of: date)!
    return Calendar.current.date(bySetting: .second, value: 0, of: date)!
  }
}

#endif
