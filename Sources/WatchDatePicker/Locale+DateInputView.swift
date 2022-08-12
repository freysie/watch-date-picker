import Foundation

extension Locale {
  /// Whether the month comes before the day in this locale.
  public var monthComesBeforeDay: Bool {
    let format = DateFormatter.dateFormat(fromTemplate: "Md", options: 0, locale: self)!
    let dayCharacters: Set<Character> = ["d", "D", "f", "g"]
    let monthCharacters: Set<Character> = ["M", "L"]
    let dayIndex = format.firstIndex(where: { dayCharacters.contains($0) }) ?? format.endIndex
    let monthIndex = format.firstIndex(where: { monthCharacters.contains($0) }) ?? format.endIndex
    return monthIndex < dayIndex
  }
  
  // TODO: find out if system’s date picker uses year first in e.g. Swedish or English (Canada), and if so, do this:
  //  public var dateComponentOrder: [Calendar.Component] {
  //    let format = DateFormatter.dateFormat(fromTemplate: "yMd", options: 0, locale: self)!
  //    let dayChars: Set<Character> = ["d", "D", "f", "g"]
  //    let monthChars: Set<Character> = ["M", "L"]
  //    let yearChars: Set<Character> = ["y", "Y", "u", "U", "r"]
  //    let dayCharIndex = format.firstIndex(where: { dayChars.contains($0) })!
  //    let monthCharIndex = format.firstIndex(where: { monthChars.contains($0) })!
  //    let yearCharIndex = format.firstIndex(where: { yearChars.contains($0) })!
  //    return …
  //  }
}
