//#if os(watchOS)

import SwiftUI
import WatchKit

fileprivate let now = Date()
fileprivate let calendar = Calendar.current
fileprivate let thisYear = calendar.component(.year, from: now)

// TODO: move most of the configuration options to environment values

/// A control for the inputting of date and time values.
public struct DatePicker: View {
  /// Styles that determine the appearance of a date picker.
  public enum Mode {
    /// Displays hour, minute, and optionally AM/PM designation depending on the locale setting (e.g. 6 | 53 | PM)
    case time
    
    /// Displays month, day, and year depending on the locale setting (e.g. November | 15 | 2007)
    case date
    
    /// Displays date, hour, minute, and optionally AM/PM designation depending on the locale setting (e.g. Wed Nov 15 | 6 | 53 | PM)
    case dateAndTime
  }
  
  /// The key for the localized title of `self`, describing its purpose.
  public var titleKey: LocalizedStringKey?
  
  // TODO: fully wire selection up
  /// The date value being displayed and selected.
  @Binding public var selection: Date
  
  /// The style that the date picker is using for its layout.
  public var mode: Mode = .dateAndTime
  
  /// The minimum date that a date picker can show.
  public var minimumDate: Date?
  
  /// The maximum date that a date picker can show.
  public var maximumDate: Date?
  
  /// The date style of the displayed value.
  public var dateStyle: DateFormatter.Style = .short
  
  /// The time style of the displayed value.
  public var timeStyle: DateFormatter.Style = .short
  
  /// Whether to display month before day. (MM DD YYYY vs. DD MM YYYY)
  public var showsMonthBeforeDay: Bool?
  
  /// Whether to use a 24-hour clock system where the day runs from midnight to midnight, dividing into 24 hours.
  public var twentyFourHour: Bool?
  
  /// A callback that will be invoked when the operation has succeeded.
  public var onCompletion: ((Date) -> Void)?
  
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
    return formatter.string(from: selection)
  }
  
  /// Creates a date picker instance.
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
    .fullScreenCover(isPresented: $pickerViewIsPresented) {
      NavigationView {
        DatePickerView(
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
      TimePickerView(mode: .time, selectionIndicatorColor: .mint)
        .toolbar {
          ToolbarItem(placement: .cancellationAction) {
            Button("Cancel", role: .cancel, action: {})
          }
        }
    }
    .previewDevice(PreviewDevice(rawValue: "Apple Watch Series 6 - 44mm"))
    .previewDisplayName("Mode: Time")
    
    NavigationView {
      DatePickerView(mode: .date)
        .toolbar {
          ToolbarItem(placement: .cancellationAction) {
            Button("Cancel", role: .cancel, action: {})
          }
        }
    }
    .previewDevice(PreviewDevice(rawValue: "Apple Watch Series 6 - 44mm"))
    .previewDisplayName("Mode: Date")
    .environment(\.locale, Locale(identifier: "da-DK"))
    
    NavigationView {
      DatePickerView(mode: .dateAndTime)
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
        TimePickerView(mode: .dateAndTime, twentyFourHour: true)
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

//#endif
