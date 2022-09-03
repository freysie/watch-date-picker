import SwiftUI

@available(watchOS 8, *)
@available(macOS, unavailable)
@available(iOS, unavailable)
@available(tvOS, unavailable)
public extension View {
  /// Sets whether date pickers flip the order of their label and value within this view.
  /// - Parameters:
  ///   - enabled: A Boolean value that determines whether date pickers flip the order of their label and value within this view.
  func datePickerFlipsLabelAndValue(_ enabled: Bool? = true) -> some View {
    environment(\.datePickerFlipsLabelAndValue, enabled)
  }

  /// Sets the interaction style of date pickers within this view. That is, whether the picking interface is presented as a sheet or pushed onto the navigation stack.
  /// - Parameters:
  ///   - style: The interaction style.
  func datePickerInteractionStyle(_ style: DatePickerInteractionStyle) -> some View {
    environment(\.datePickerInteractionStyle, style)
  }

  // /// Sets whether date pickers use bottom buttons within this view.
  // /// - Parameters:
  // ///   - enabled: A Boolean value that determines whether date pickers use bottom buttons within this view.
  // func datePickerUsesBottomButtons(_ enabled: Bool? = true) -> some View {
  //   environment(\.datePickerUsesBottomButtons, enabled)
  // }

  // /// Sets the confirmation button title key for date pickers within this view.
  // /// - Parameters:
  // ///   - key: A localized string key for overriding the confirmation button’s title.
  // func datePickerConfirmationTitle(_ key: LocalizedStringKey?) -> some View {
  //   environment(\.datePickerConfirmationTitleKey, key)
  // }

  // /// Sets the confirmation button color for date pickers within this view.
  // /// - Parameters:
  // ///   - tint: The tint to use for the confirmation button.
  // func datePickerConfirmationTint(_ tint: Color?) -> some View {
  //   environment(\.datePickerConfirmationTint, tint)
  // }
}

@available(watchOS 8, *)
@available(macOS, unavailable)
@available(iOS, unavailable)
@available(tvOS, unavailable)
public extension EnvironmentValues {
  var datePickerFlipsLabelAndValue: Bool? {
    get { self[DatePickerFlipsLabelAndValueKey.self] }
    set { self[DatePickerFlipsLabelAndValueKey.self] = newValue }
  }
  
  var datePickerInteractionStyle: DatePickerInteractionStyle {
    get { self[DatePickerInteractionStyleKey.self] }
    set { self[DatePickerInteractionStyleKey.self] = newValue }
  }
  
  // var datePickerUsesBottomButtons: Bool? {
  //   get { self[DatePickerUsesBottomButtonsKey.self] }
  //   set { self[DatePickerUsesBottomButtonsKey.self] = newValue }
  // }

  // var datePickerConfirmationTitleKey: LocalizedStringKey? {
  //   get { self[DatePickerConfirmationTitleKeyKey.self] }
  //   set { self[DatePickerConfirmationTitleKeyKey.self] = newValue }
  // }
  //
  // var datePickerConfirmationTint: Color? {
  //   get { self[DatePickerConfirmationTintKey.self] }
  //   set { self[DatePickerConfirmationTintKey.self] = newValue }
  // }
}

struct DatePickerFlipsLabelAndValueKey: EnvironmentKey { static let defaultValue: Bool? = nil }
struct DatePickerInteractionStyleKey: EnvironmentKey { static let defaultValue = DatePickerInteractionStyle.sheet }

// struct DatePickerUsesBottomButtonsKey: EnvironmentKey { static let defaultValue: Bool? = nil }

//struct DatePickerConfirmationTitleKeyKey: EnvironmentKey { static let defaultValue: LocalizedStringKey? = nil }
//struct DatePickerConfirmationTintKey: EnvironmentKey { static let defaultValue: Color? = .green }
