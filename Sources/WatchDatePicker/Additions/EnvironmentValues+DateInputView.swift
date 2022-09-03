import SwiftUI

@available(watchOS 8, *)
@available(macOS, unavailable)
@available(iOS, unavailable)
@available(tvOS, unavailable)
public extension View {
  /// Sets whether date input views show month before day within this view.
  /// - Parameters:
  ///   - enabled: A Boolean value that determines whether date input views show month before day within this view.
  func dateInputViewShowsMonthBeforeDay(_ enabled: Bool? = true) -> some View {
    environment(\.dateInputViewShowsMonthBeforeDay, enabled)
  }

  /// Sets the text case for date input views within this view.
  /// - Parameters:
  ///   - case: The text case to use.
  func dateInputViewTextCase(_ case: Text.Case?) -> some View {
    environment(\.dateInputViewTextCase, `case`)
  }
}

@available(watchOS 8, *)
@available(macOS, unavailable)
@available(iOS, unavailable)
@available(tvOS, unavailable)
public extension EnvironmentValues {
  var dateInputViewShowsMonthBeforeDay: Bool? {
    get { self[DateInputViewShowsMonthBeforeDayKey.self] }
    set { self[DateInputViewShowsMonthBeforeDayKey.self] = newValue }
  }
  
  var dateInputViewTextCase: Text.Case? {
    get { self[DateInputViewTextCaseKey.self] }
    set { self[DateInputViewTextCaseKey.self] = newValue }
  }
}

struct DateInputViewShowsMonthBeforeDayKey: EnvironmentKey { static let defaultValue: Bool? = nil }
struct DateInputViewTextCaseKey: EnvironmentKey { static let defaultValue: Text.Case? = .uppercase }
