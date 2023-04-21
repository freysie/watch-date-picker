#if os(watchOS)

import SwiftUI

@available(watchOS 8, *)
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

  /// Sets the color for the component borders of date input views within this view.
  /// - Parameters:
  ///   - tint: The color for the component borders.
  func dateInputViewPickertBorderColor(_ color: Color?) -> some View {
    environment(\.dateInputViewPickerBorderColor, color)
  }

  /// Sets the color for the focus outline of time date views within this view.
  /// - Parameters:
  ///   - tint: The color for the focus outline.
  func dateInputViewFocusTint(_ tint: Color?) -> some View {
    environment(\.dateInputViewFocusTint, tint)
  }
}

@available(watchOS 8, *)
public extension EnvironmentValues {
  var dateInputViewShowsMonthBeforeDay: Bool? {
    get { self[DateInputViewShowsMonthBeforeDayKey.self] }
    set { self[DateInputViewShowsMonthBeforeDayKey.self] = newValue }
  }
  
  var dateInputViewTextCase: Text.Case? {
    get { self[DateInputViewTextCaseKey.self] }
    set { self[DateInputViewTextCaseKey.self] = newValue }
  }

  var dateInputViewPickerBorderColor: Color? {
    get { self[DateInputViewPickerBorderColorKey.self] }
    set { self[DateInputViewPickerBorderColorKey.self] = newValue }
  }

  var dateInputViewFocusTint: Color? {
    get { self[DateInputViewFocusTintKey.self] }
    set { self[DateInputViewFocusTintKey.self] = newValue }
  }
}

struct DateInputViewShowsMonthBeforeDayKey: EnvironmentKey { static let defaultValue: Bool? = nil }
struct DateInputViewTextCaseKey: EnvironmentKey { static let defaultValue: Text.Case? = nil }
struct DateInputViewPickerBorderColorKey: EnvironmentKey { static let defaultValue: Color? = nil }
struct DateInputViewFocusTintKey: EnvironmentKey { static let defaultValue: Color? = nil }

#endif
