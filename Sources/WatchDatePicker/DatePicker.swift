import SwiftUI

// TODO: move most of the configuration options to environment values
// TODO: determine `datePickerTwentyFourHour` automatically based on locale
// TODO: showsMonthBeforeDay: showsMonthBeforeDay ?? locale.monthComesBeforeDay

/// A control for the inputting of date and time values.
///
/// The `DatePicker` view displays a button with a title and the selected value. When pressed, it presents a sheet with user interfaces for selecting date and time. The view binds to a `Date` instance.
///
/// ![](DateAndTimeMode.png)
@available(watchOS 8, *)
@available(macOS, unavailable)
@available(iOS, unavailable)
@available(tvOS, unavailable)
public struct DatePicker: View {
  public enum Mode {
    case time
    case date
    case dateAndTime
  }

  var titleKey: LocalizedStringKey?
  @Binding var selection: Date
  var mode: Mode = .dateAndTime
  var minimumDate: Date?
  var maximumDate: Date?
  var dateStyle: DateFormatter.Style = .short
  var timeStyle: DateFormatter.Style = .short
  let displayedComponents: Components
  var onCompletion: ((Date) -> Void)?
  
  private func _onCompletion(_ date: Date) {
    pickerViewIsPresented = false
    onCompletion?(date)
  }
  
  @State private var pickerViewIsPresented = false
  
  @Environment(\.datePickerShowsMonthBeforeDay) private var showsMonthBeforeDay
  @Environment(\.datePickerTwentyFourHour) private var twentyFourHour
  
  @Environment(\.locale) private var locale
  
  private var formattedSelection: String {
    let formatter = DateFormatter()
    formatter.locale = locale
    formatter.dateStyle = mode == .time ? .none : dateStyle
    formatter.timeStyle = mode == .date ? .none : timeStyle
    if twentyFourHour == true && mode == .time {
      formatter.dateFormat = "HH:mm"
    }
    return formatter.string(from: selection)
  }
  
  /// Option set that determines the displayed components of a date picker.
  ///
  /// Specifying ``date`` displays month, day, and year depending on the locale setting:
  /// ![](TimeMode.png)
  /// Specifying ``hourAndMinute`` displays hour, minute, and optionally AM/PM designation depending on the locale setting:
  /// ![](DateMode.png)
  /// Specifying both ``date`` and ``hourAndMinute`` displays date, hour, minute, and optionally AM/PM designation depending on the locale setting:
  /// ![](DateAndTimeMode.png)
  public struct Components: OptionSet {
    public let rawValue: UInt
    public init(rawValue: UInt) { self.rawValue = rawValue }
    
    /// Displays day, month, and year based on the locale.
    public static let date = Self(rawValue: 1 << 0)
    /// Displays hour and minute components based on the locale.
    public static let hourAndMinute = Self(rawValue: 1 << 1)
  }
  
  /// Creates an instance that selects a Date with an unbounded range.
  /// - Parameters:
  ///   - label: The key for the localized title of `self`, describing its purpose.
  ///   - selection: The date value being displayed and selected.
  ///   - displayedComponents: The date components that user is able to view and edit. Defaults to `[.hourAndMinute, .date]`.
  public init(
    _ titleKey: LocalizedStringKey,
    selection: Binding<Date>,
    displayedComponents: Components = [.hourAndMinute, .date]
  ) {
    self.titleKey = titleKey
    _selection = selection
    self.displayedComponents = displayedComponents
  }
  
  /// Creates an instance that selects a Date in a closed range.
  /// - Parameters:
  ///   - label: The key for the localized title of `self`, describing its purpose.
  ///   - selection: The date value being displayed and selected.
  ///   - range: The inclusive range of selectable dates.
  ///   - displayedComponents: The date components that user is able to view and edit. Defaults to `[.hourAndMinute, .date]`.
  public init(
    _ titleKey: LocalizedStringKey,
    selection: Binding<Date>,
    in range: ClosedRange<Date>,
    displayedComponents: Components = [.hourAndMinute, .date]
  ) {
    self.titleKey = titleKey
    _selection = selection
    minimumDate = range.lowerBound
    maximumDate = range.upperBound
    self.displayedComponents = displayedComponents
  }
  
  /// Creates an instance that selects a Date on or after some start date.
  /// - Parameters:
  ///   - label: The key for the localized title of `self`, describing its purpose.
  ///   - selection: The date value being displayed and selected.
  ///   - range: The open range from some selectable start date.
  ///   - displayedComponents: The date components that user is able to view and edit. Defaults to `[.hourAndMinute, .date]`.
  public init(
    _ titleKey: LocalizedStringKey,
    selection: Binding<Date>,
    in range: PartialRangeFrom<Date>,
    displayedComponents: Components = [.hourAndMinute, .date]
  ) {
    self.titleKey = titleKey
    _selection = selection
    minimumDate = range.lowerBound
    self.displayedComponents = displayedComponents
  }
  
  /// Creates an instance that selects a Date on or before some end date.
  /// - Parameters:
  ///   - label: The key for the localized title of `self`, describing its purpose.
  ///   - selection: The date value being displayed and selected.
  ///   - range: The open range before some selectable end date.
  ///   - displayedComponents: The date components that user is able to view and edit. Defaults to `[.hourAndMinute, .date]`.
  public init(
    _ titleKey: LocalizedStringKey,
    selection: Binding<Date>,
    in range: PartialRangeThrough<Date>,
    displayedComponents: Components = [.hourAndMinute, .date]
  ) {
    self.titleKey = titleKey
    _selection = selection
    maximumDate = range.upperBound
    self.displayedComponents = displayedComponents
  }

  /// Creates a date picker instance with the specified properties.
  /// - Parameters:
  ///   - label: The key for the localized title of `self`, describing its purpose.
  ///   - selection: The date value being displayed and selected.
  ///   - mode: The style that the date picker is using for its layout.
  ///   - minimumDate: The minimum date that a date picker can show.
  ///   - maximumDate: The maximum date that a date picker can show.
  ///   - showsMonthBeforeDay: Whether to display month before day. (MM DD YYYY vs. DD MM YYYY)
  ///   - twentyFourHour: Whether to use a 24-hour clock system where the day runs from midnight to midnight, dividing into 24 hours.
  ///   - onCompletion: A callback that will be invoked when the operation has succeeded.
  public init(
    _ label: LocalizedStringKey,
    selection: Binding<Date>,
    mode: Mode? = nil,
    minimumDate: Date? = nil,
    maximumDate: Date? = nil,
    onCompletion: ((Date) -> Void)? = nil
  ) {
    self.titleKey = label
    _selection = selection
    if let value = mode { self.mode = value }
    self.minimumDate = minimumDate
    self.maximumDate = maximumDate
    self.onCompletion = onCompletion
    displayedComponents = [.hourAndMinute, .date]
  }

  /// The content and behavior of the view.
  public var body: some View {
    Button(action: { pickerViewIsPresented = true }) {
      VStack(alignment: .leading) {
        if let label = titleKey {
          Text(label)
        }
        
        Text(formattedSelection)
          .font(titleKey != nil ? .footnote : .body)
          .foregroundStyle(titleKey != nil ? .secondary : .primary)
      }
    }
    // TODO: determine the exact differences (if any) between `.sheet` and this on watchOS:
    .fullScreenCover(isPresented: $pickerViewIsPresented) {
      NavigationView {
        DatePickerView(
          selection: $selection,
          mode: mode,
          minimumDate: minimumDate,
          maximumDate: maximumDate,
          onCompletion: _onCompletion
        )
      }
    }
  }
}

@available(macOS, unavailable)
@available(iOS, unavailable)
@available(tvOS, unavailable)
struct DatePicker_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      TimePickerView(selection: .constant(Date()), mode: .time)
        .datePickerSelectionIndicatorFill(.mint)
        .toolbar {
          ToolbarItem(placement: .cancellationAction) {
            Button("Cancel", role: .cancel, action: {})
          }
        }
    }
    .previewDevice(PreviewDevice(rawValue: "Apple Watch Series 6 - 44mm"))
    .previewDisplayName("Mode: Time")
    
    NavigationView {
      DatePickerView(selection: .constant(Date()), mode: .date)
        .toolbar {
          ToolbarItem(placement: .cancellationAction) {
            Button("Cancel", role: .cancel, action: {})
          }
        }
    }
    .previewDevice(PreviewDevice(rawValue: "Apple Watch Series 6 - 44mm"))
    .previewDisplayName("Mode: Date (Series 6 – 44mm)")
    .environment(\.locale, Locale(identifier: "da-DK"))
    
    NavigationView {
      DatePickerView(selection: .constant(Date()), mode: .date)
        .toolbar {
          ToolbarItem(placement: .cancellationAction) {
            Button("Cancel", role: .cancel, action: {})
          }
        }
    }
    .previewDevice(PreviewDevice(rawValue: "Apple Watch Series 7 - 45mm"))
    .previewDisplayName("Mode: Date (Series 7 – 45mm)")
    .environment(\.locale, Locale(identifier: "da-DK"))
    
    NavigationView {
      DatePickerView(selection: .constant(Date()), mode: .dateAndTime)
        .toolbar {
          ToolbarItem(placement: .cancellationAction) {
            Button("Cancel", role: .cancel, action: {})
          }
        }
    }
    .previewDevice(PreviewDevice(rawValue: "Apple Watch Series 6 - 44mm"))
    .previewDisplayName("Mode: Date & Time (Step 1)")
    
    NavigationView {
      NavigationLink(isActive: .constant(true)) {
        TimePickerView(selection: .constant(Date()), mode: .dateAndTime)
          .datePickerTwentyFourHour()
          .tint(.pink)
      } label: {
        EmptyView()
      }
      .opacity(0)
    }
    .previewDevice(PreviewDevice(rawValue: "Apple Watch Series 6 - 44mm"))
    .previewDisplayName("Mode: Date & Time (Step 2)")
  }
}
