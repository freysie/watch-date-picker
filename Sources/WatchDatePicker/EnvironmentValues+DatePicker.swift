import SwiftUI

@available(watchOS 8, *)
public extension View {
  /// Sets whether date pickers shows month before day within this view.
  /// - Parameters:
  ///   - enabled: A Boolean value that determines whether date pickers shows month before day within this view.
  func datePickerShowsMonthBeforeDay(_ enabled: Bool?) -> some View {
    environment(\.datePickerShowsMonthBeforeDay, enabled)
  }
  
  /// Sets whether date pickers use twenty four hour mode within this view.
  /// - Parameters:
  ///   - enabled: A Boolean value that determines whether date pickers use twenty four hour mode within this view.
  func datePickerTwentyFourHour(_ enabled: Bool?) -> some View {
    environment(\.datePickerTwentyFourHour, enabled)
  }

  /// Sets whether date pickers show the twenty four hour mode indicator within this view.
  /// - Parameters:
  ///   - enabled: A Boolean value that determines whether date pickers show the twenty four hour mode indicator within this view.
  func datePickerTwentyFourHourIndicator(_ enabled: Bool) -> some View {
    environment(\.datePickerTwentyFourHourIndicator, enabled)
  }

  /// Sets the confirmation button title key for date pickers within this view.
  /// - Parameters:
  ///   - key: …
  func datePickerConfirmationTitleKey(_ key: LocalizedStringKey?) -> some View {
    environment(\.datePickerConfirmationTitleKey, key)
  }
  
  /// Sets the confirmation button title color for date pickers within this view.
  /// - Parameters:
  ///   - color: …
  func datePickerConfirmationColor(_ color: Color?) -> some View {
    environment(\.datePickerConfirmationColor, color)
  }
  
  /// Sets the AM/PM highlight color for date pickers within this view.
  /// - Parameters:
  ///   - color: …
  func datePickerAMPMHighlightColor(_ color: Color?) -> some View {
    environment(\.datePickerAMPMHighlightColor, color)
  }
  
  /// Sets the color for the focus outline of time fields in date pickers within this view.
  /// - Parameters:
  ///   - color: …
  func datePickerFocusColor(_ color: Color?) -> some View {
    environment(\.datePickerFocusColor, color)
  }
}

@available(watchOS 8, *)
public extension EnvironmentValues {
  var datePickerShowsMonthBeforeDay: Bool? {
    get { self[DatePickerShowsMonthBeforeDay.self] }
    set { self[DatePickerShowsMonthBeforeDay.self] = newValue }
  }
  
  var datePickerTwentyFourHour: Bool? {
    get { self[DatePickerTwentyFourHour.self] }
    set { self[DatePickerTwentyFourHour.self] = newValue }
  }
  
  var datePickerTwentyFourHourIndicator: Bool {
    get { self[DatePickerTwentyFourHourIndicator.self] }
    set { self[DatePickerTwentyFourHourIndicator.self] = newValue }
  }

  var datePickerConfirmationTitleKey: LocalizedStringKey? {
    get { self[DatePickerConfirmationTitleKey.self] }
    set { self[DatePickerConfirmationTitleKey.self] = newValue }
  }

  var datePickerConfirmationColor: Color? {
    get { self[DatePickerConfirmationColor.self] }
    set { self[DatePickerConfirmationColor.self] = newValue }
  }

  var datePickerAMPMHighlightColor: Color? {
    get { self[DatePickerAMPMHighlightColor.self] }
    set { self[DatePickerAMPMHighlightColor.self] = newValue }
  }

  var datePickerFocusColor: Color? {
    get { self[DatePickerFocusColor.self] }
    set { self[DatePickerFocusColor.self] = newValue }
  }
}

struct DatePickerShowsMonthBeforeDay: EnvironmentKey { static let defaultValue: Bool? = nil }
struct DatePickerTwentyFourHour: EnvironmentKey { static let defaultValue: Bool? = nil }
struct DatePickerTwentyFourHourIndicator: EnvironmentKey { static let defaultValue: Bool = false }
struct DatePickerConfirmationTitleKey: EnvironmentKey { static let defaultValue: LocalizedStringKey? = nil }
struct DatePickerConfirmationColor: EnvironmentKey { static let defaultValue: Color? = .green }
struct DatePickerAMPMHighlightColor: EnvironmentKey { static let defaultValue: Color? = nil }
struct DatePickerFocusColor: EnvironmentKey { static let defaultValue: Color? = .green }
