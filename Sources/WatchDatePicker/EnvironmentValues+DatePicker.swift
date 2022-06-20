import SwiftUI

@available(watchOS 8, *)
public extension View {
  /// Sets whether date pickers shows month before day within this view.
  /// - Parameters:
  ///   - enabled: A Boolean value that determines whether date pickers shows month before day within this view.
  func datePickerShowsMonthBeforeDay(_ enabled: Bool? = true) -> some View {
    environment(\.datePickerShowsMonthBeforeDay, enabled)
  }
  
  /// Sets whether date pickers use twenty four hour mode within this view.
  /// - Parameters:
  ///   - enabled: A Boolean value that determines whether date pickers use twenty four hour mode within this view.
  func datePickerTwentyFourHour(_ enabled: Bool? = true) -> some View {
    environment(\.datePickerTwentyFourHour, enabled)
  }
  
  /// Sets whether date pickers show the twenty four hour mode indicator within this view.
  /// - Parameters:
  ///   - enabled: A Boolean value that determines whether date pickers show the twenty four hour mode indicator within this view.
  func datePickerTwentyFourHourIndicator(_ visibility: Visibility) -> some View {
    environment(\.datePickerTwentyFourHourIndicator, visibility)
  }
  
  /// Sets the confirmation button title key for date pickers within this view.
  /// - Parameters:
  ///   - key: …
  func datePickerConfirmationTitle(_ key: LocalizedStringKey?) -> some View {
    environment(\.datePickerConfirmationTitleKey, key)
  }
  
  /// Sets the confirmation button title color for date pickers within this view.
  /// - Parameters:
  ///   - tint: …
  func datePickerConfirmationTint(_ tint: Color?) -> some View {
    environment(\.datePickerConfirmationTint, tint)
  }
  
  /// Sets the AM/PM highlight color for date pickers within this view.
  /// - Parameters:
  ///   - tint: …
  func datePickerAMPMHighlightTint(_ tint: Color?) -> some View {
    environment(\.datePickerAMPMHighlightTint, tint)
  }
  
  /// Sets the color for the focus outline of time fields in date pickers within this view.
  /// - Parameters:
  ///   - tint: …
  func datePickerFocusTint(_ tint: Color?) -> some View {
    environment(\.datePickerFocusTint, tint)
  }
  
  func datePickerMarkSize(_ size: CGSize?) -> some View {
    environment(\.datePickerMarkSize, size)
  }
  
  func datePickerMarkFill<S>(_ fill: S) -> some View where S: ShapeStyle {
    environment(\.datePickerMarkFill, AnyShapeStyle(fill))
  }
  
  func datePickerHeavyMarkSize(_ size: CGSize?) -> some View {
    environment(\.datePickerHeavyMarkSize, size)
  }
  
  func datePickerHeavyMarkFill<S>(_ fill: S) -> some View where S: ShapeStyle {
    environment(\.datePickerHeavyMarkFill, AnyShapeStyle(fill))
  }
  
//  func datePickerSelectionIndicatorShape<S>(_ shape: S) -> some View where S: Shape {
//    environment(\.datePickerSelectionIndicatorShape, AnyView(shape))
//  }

  func datePickerSelectionIndicatorRadius(_ radius: CGFloat?) -> some View {
    environment(\.datePickerSelectionIndicatorRadius, radius)
  }

  func datePickerSelectionIndicatorFill<S>(_ style: S) -> some View where S: ShapeStyle {
    environment(\.datePickerSelectionIndicatorFill, AnyShapeStyle(style))
  }
}

//@available(watchOS 9, *)
//public extension View {
//  /// Sets the shape used for marks in clock faces of date pickers within this view.
//  /// - Parameters:
//  ///   - tint: …
//  func datePickerMark<Content: View>(@ViewBuilder content: () -> Content) -> some View {
//    environment(\.datePickerMark, AnyShape(content()))
//  }
//
//  /// Sets the shape used for heavy marks in clock faces of date pickers within this view.
//  /// - Parameters:
//  ///   - tint: …
//  func datePickerHeavyMark<Content: View>(@ViewBuilder content: () -> Content) -> some View {
//    environment(\.datePickerHeavyMark, AnyShape(content()))
//  }
//
//  /// Sets the shape used for the selection indicator in clock faces of date pickers within this view.
//  /// - Parameters:
//  ///   - tint: …
//  func datePickerSelectionIndicator<Content: View>(@ViewBuilder content: () -> Content) -> some View {
//    environment(\.datePickerSelectionIndicator, AnyShape(content()))
//  }
//}

@available(watchOS 8, *)
public extension EnvironmentValues {
  var datePickerShowsMonthBeforeDay: Bool? {
    get { self[DatePickerShowsMonthBeforeDayKey.self] }
    set { self[DatePickerShowsMonthBeforeDayKey.self] = newValue }
  }
  
  var datePickerTwentyFourHour: Bool? {
    get { self[DatePickerTwentyFourHourKey.self] }
    set { self[DatePickerTwentyFourHourKey.self] = newValue }
  }
  
  var datePickerTwentyFourHourIndicator: Visibility {
    get { self[DatePickerTwentyFourHourIndicatorKey.self] }
    set { self[DatePickerTwentyFourHourIndicatorKey.self] = newValue }
  }
  
  var datePickerConfirmationTitleKey: LocalizedStringKey? {
    get { self[DatePickerConfirmationTitleKeyKey.self] }
    set { self[DatePickerConfirmationTitleKeyKey.self] = newValue }
  }
  
  var datePickerConfirmationTint: Color? {
    get { self[DatePickerConfirmationTintKey.self] }
    set { self[DatePickerConfirmationTintKey.self] = newValue }
  }
  
  var datePickerAMPMHighlightTint: Color? {
    get { self[DatePickerAMPMHighlightTintKey.self] }
    set { self[DatePickerAMPMHighlightTintKey.self] = newValue }
  }
  
  var datePickerFocusTint: Color? {
    get { self[DatePickerFocusTintKey.self] }
    set { self[DatePickerFocusTintKey.self] = newValue }
  }
  
  var datePickerMarkSize: CGSize? {
    get { self[DatePickerMarkSizeKey.self] }
    set { self[DatePickerMarkSizeKey.self] = newValue }
  }

  var datePickerMarkFill: AnyShapeStyle? {
    get { self[DatePickerMarkFillKey.self] }
    set { self[DatePickerMarkFillKey.self] = newValue }
  }

  var datePickerHeavyMarkSize: CGSize? {
    get { self[DatePickerHeavyMarkSizeKey.self] }
    set { self[DatePickerHeavyMarkSizeKey.self] = newValue }
  }

  var datePickerHeavyMarkFill: AnyShapeStyle? {
    get { self[DatePickerHeavyMarkFillKey.self] }
    set { self[DatePickerHeavyMarkFillKey.self] = newValue }
  }

//  var datePickerSelectionIndicatorShape: AnyView? {
//    get { self[DatePickerSelectionIndicatorShapeKey.self] }
//    set { self[DatePickerSelectionIndicatorShapeKey.self] = newValue }
//  }
  
  var datePickerSelectionIndicatorRadius: CGFloat? {
    get { self[DatePickerSelectionIndicatorRadiusKey.self] }
    set { self[DatePickerSelectionIndicatorRadiusKey.self] = newValue }
  }

  var datePickerSelectionIndicatorFill: AnyShapeStyle? {
    get { self[DatePickerSelectionIndicatorFillKey.self] }
    set { self[DatePickerSelectionIndicatorFillKey.self] = newValue }
  }
}

//public extension EnvironmentValues {
//
//}

//@available(watchOS 9, *)
//public extension EnvironmentValues {
//  var datePickerMark: AnyShape? {
//    get { self[DatePickerMarkKey.self] }
//    set { self[DatePickerMarkKey.self] = newValue }
//  }
//
//  var datePickerHeavyMark: AnyShape? {
//    get { self[DatePickerHeavyMarkKey.self] }
//    set { self[DatePickerHeavyMarkKey.self] = newValue }
//  }
//
//  var datePickerSelectionIndicator: AnyShape? {
//    get { self[DatePickerSelectionIndicatorKey.self] }
//    set { self[DatePickerSelectionIndicatorKey.self] = newValue }
//  }
//}

struct DatePickerShowsMonthBeforeDayKey: EnvironmentKey { static let defaultValue: Bool? = nil }
struct DatePickerTwentyFourHourKey: EnvironmentKey { static let defaultValue: Bool? = nil }
struct DatePickerTwentyFourHourIndicatorKey: EnvironmentKey { static let defaultValue: Visibility = .automatic }
struct DatePickerConfirmationTitleKeyKey: EnvironmentKey { static let defaultValue: LocalizedStringKey? = nil }
struct DatePickerConfirmationTintKey: EnvironmentKey { static let defaultValue: Color? = .green }
struct DatePickerAMPMHighlightTintKey: EnvironmentKey { static let defaultValue: Color? = nil }
struct DatePickerFocusTintKey: EnvironmentKey { static let defaultValue: Color? = .green }

struct DatePickerSelectionIndicatorShapeKey: EnvironmentKey { static let defaultValue: AnyView? = nil }

struct DatePickerMarkSizeKey: EnvironmentKey { static let defaultValue: CGSize? = nil }
struct DatePickerMarkFillKey: EnvironmentKey { static let defaultValue: AnyShapeStyle? = nil }
struct DatePickerHeavyMarkSizeKey: EnvironmentKey { static let defaultValue: CGSize? = nil }
struct DatePickerHeavyMarkFillKey: EnvironmentKey { static let defaultValue: AnyShapeStyle? = nil }
struct DatePickerSelectionIndicatorRadiusKey: EnvironmentKey { static let defaultValue: CGFloat? = nil }
struct DatePickerSelectionIndicatorFillKey: EnvironmentKey { static let defaultValue: AnyShapeStyle? = nil }

//@available(watchOS 9, *)
//struct DatePickerMarkKey: EnvironmentKey { static let defaultValue: AnyShape? = nil }
//@available(watchOS 9, *)
//struct DatePickerHeavyMarkKey: EnvironmentKey { static let defaultValue: AnyShape? = nil }
//@available(watchOS 9, *)
//struct DatePickerSelectionIndicatorKey: EnvironmentKey { static let defaultValue: AnyShape? = nil }
