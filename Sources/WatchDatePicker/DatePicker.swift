import SwiftUI

// TODO: move most of the configuration options to environment values

/// A control for the inputting of date and time values.
///
/// The `DatePicker` view displays a button with a title and the selected value. When pressed, it presents a sheet with user interfaces for selecting date and time. The view binds to a `Date` instance.
///
/// ![](DateAndTimeMode.png)
@available(watchOS 8, *)
public struct DatePicker: View {
  /// Styles that determine the appearance of a date picker.
  public enum Mode {
    /// Displays hour, minute, and optionally AM/PM designation depending on the locale setting (e.g. 6 | 53 | PM)
    /// ![](TimeMode.png)
    case time
    
    /// Displays month, day, and year depending on the locale setting (e.g. November | 15 | 2007)
    /// ![](DateMode.png)
    case date
    
    /// Displays date, hour, minute, and optionally AM/PM designation depending on the locale setting (e.g. Wed Nov 15 | 6 | 53 | PM)
    /// ![](DateAndTimeMode.png)
    case dateAndTime
  }

  var titleKey: LocalizedStringKey?
  @Binding var selection: Date
  var mode: Mode = .dateAndTime
  var minimumDate: Date?
  var maximumDate: Date?
  var dateStyle: DateFormatter.Style = .short
  var timeStyle: DateFormatter.Style = .short
  var showsMonthBeforeDay: Bool?
  var twentyFourHour: Bool?
  var onCompletion: ((Date) -> Void)?
  
  private func _onCompletion(_ date: Date) {
    pickerViewIsPresented = false
    onCompletion?(date)
  }
  
  @State private var pickerViewIsPresented = false
  
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
  
  /// Creates a date picker instance with the specified properties.
  /// - Parameters:
  ///   - label: The key for the localized title of `self`, describing its purpose.
  ///   - selection:The date value being displayed and selected.
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
    showsMonthBeforeDay: Bool? = nil,
    twentyFourHour: Bool? = nil,
    onCompletion: ((Date) -> Void)? = nil
  ) {
    self.titleKey = label
    _selection = selection
    if let value = mode { self.mode = value }
    self.minimumDate = minimumDate
    self.maximumDate = maximumDate
    self.showsMonthBeforeDay = showsMonthBeforeDay
    self.twentyFourHour = twentyFourHour
    self.onCompletion = onCompletion
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
          showsMonthBeforeDay: showsMonthBeforeDay ?? locale.monthComesBeforeDay,
          twentyFourHour: twentyFourHour ?? false, // TODO: determine automatically based on locale
          onCompletion: _onCompletion
        )
      }
    }
  }
}

struct DatePicker_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      TimePickerView(selection: .constant(Date()), mode: .time, selectionIndicatorColor: .mint)
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
        TimePickerView(selection: .constant(Date()), mode: .dateAndTime, twentyFourHour: true)
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
