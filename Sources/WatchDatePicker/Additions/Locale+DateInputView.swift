import Foundation

extension Locale {
  /// Whether this locale uses 24-hour time cycle as opposed to AM/PM.
  public var uses24HourTime: Bool {
    !DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: self)!.contains("a")
  }

  /// Whether the month comes before the day in this locale.
  public var monthComesBeforeDay: Bool {
    let format = DateFormatter.dateFormat(fromTemplate: "Md", options: 0, locale: self)!
    let dayCharacters: Set<Character> = ["d", "D", "f", "g"]
    let monthCharacters: Set<Character> = ["M", "L"]
    let dayIndex = format.firstIndex(where: { dayCharacters.contains($0) }) ?? format.endIndex
    let monthIndex = format.firstIndex(where: { monthCharacters.contains($0) }) ?? format.endIndex
    return monthIndex < dayIndex
  }
}
