#if os(watchOS)

import Foundation

extension Locale {
  /// Whether this locale uses 24-hour time cycle as opposed to AM/PM.
  public var uses24HourTime: Bool {
    !DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: self)!.contains("a")
  }

  /// Whether the month comes before the day when displayed in this locale.
  public var showsMonthBeforeDay: Bool {
    let format = DateFormatter.dateFormat(fromTemplate: "Md", options: 0, locale: self)!
    let dayCharacters: Set<Character> = ["d", "D", "f", "g"]
    let monthCharacters: Set<Character> = ["M", "L"]
    let dayIndex = format.firstIndex { dayCharacters.contains($0) } ?? format.endIndex
    let monthIndex = format.firstIndex { monthCharacters.contains($0) } ?? format.endIndex
    return monthIndex < dayIndex
  }

  /// The time separator for this locale. Either “.” or “:”.
  public var timeSeparator: String {
    calendar.startOfDay(for: Date())
      .formatted(Date.FormatStyle(date: .none, time: .shortened, locale: self, calendar: calendar))
      .contains(".") ? "." : ":"
  }

  /// A list of identifiers supported by Watch Date Picker.
  public static let watchDatePickerSupportedIdentifiers = Bundle.module.localizations
}

#endif
