import SwiftUI

/// A control for the inputting of date values.
///
/// The `DatePickerView` displays three pickers for month, day, and year, the order of which depends on locale. It optionally shows a button which presents a time picker. The view binds to a `Date` instance.
///
/// ![](DatePickerView.png)
/// ![](DatePickerView~fr.png)
@available(watchOS 8, *)
@available(macOS, unavailable)
@available(iOS, unavailable)
@available(tvOS, unavailable)
public struct DatePickerView: View {
  @Binding var selection: Date
  var mode: DatePicker.Mode?
  var minimumDate: Date?
  var maximumDate: Date?
  var onCompletion: ((Date) -> Void)?
  
  @State private var year = 0
  @State private var month = 0
  @State private var day = 0

  @Environment(\.datePickerConfirmationTitleKey) private var confirmationTitleKey
  @Environment(\.datePickerConfirmationTint) private var confirmationTint
  @Environment(\.datePickerShowsMonthBeforeDay) private var showsMonthBeforeDay
  @Environment(\.datePickerTwentyFourHour) private var twentyFourHour

  @Environment(\.locale) private var locale
  @Environment(\.dismiss) private var dismiss
  
  private var newSelection: Date {
    locale.calendar.date(from: DateComponents(
      year: year,
      month: month,
      day: day,
      hour: locale.calendar.component(.hour, from: selection),
      minute: locale.calendar.component(.minute, from: selection)
    ))!
  }
  
  private var formattedSelection: String {
    let formatter = DateFormatter()
    formatter.locale = locale
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    return formatter.string(from: newSelection)
  }
  
  private var yearRange: Range<Int> {
    var lowerBound = 0
    var upperBound = 9999
    if let minimumDate = minimumDate {
      lowerBound = locale.calendar.component(.year, from: minimumDate)
    }
    if let maximumDate = maximumDate {
      upperBound = locale.calendar.component(.year, from: maximumDate)
    }
    return lowerBound..<(upperBound + 1)
  }
  
  private var monthSymbols: [EnumeratedSequence<[String]>.Element] {
    Array(locale.calendar.shortMonthSymbols.enumerated())
  }
  
  private var dayRange: Range<Int> {
    locale.calendar.range(of: .day, in: .month, for: newSelection)!
  }
  
  public init(
    selection: Binding<Date>,
    mode: DatePicker.Mode = .time,
    minimumDate: Date? = nil,
    maximumDate: Date? = nil,
    onCompletion: ((Date) -> Void)? = nil
  ) {
    _selection = selection
    self.mode = mode
    self.minimumDate = minimumDate
    self.maximumDate = maximumDate
    self.onCompletion = onCompletion
    _year = State(initialValue: locale.calendar.component(.year, from: self.selection))
    _month = State(initialValue: locale.calendar.component(.month, from: self.selection))
    _day = State(initialValue: locale.calendar.component(.day, from: self.selection))
  }
  
  /// The content and behavior of the view.
  public var body: some View {
    if let mode = mode, mode == .time {
      TimePickerView(
        selection: $selection,
        mode: mode,
        onCompletion: confirm
      )
    } else {
      VStack(spacing: 15) {
        componentPickers
        
        if mode != nil {
          confirmationAction
        }
      }
      .padding(.horizontal, 10)
      .padding(.vertical, 5)
      .toolbar {
        ToolbarItem(placement: .confirmationAction) {
          Button("", action: {}).foregroundColor(.clear)
        }
      }
    }
  }
  
  private func confirm(_ date: Date) {
    if mode == .date { dismiss() }
    onCompletion?(date)
    selection = date
  }
  
  private var confirmationAction: some View {
    Group {
      if let mode = mode, mode == .dateAndTime {
        NavigationLink {
          TimePickerView(
            selection: .constant(newSelection),
            mode: mode,
            onCompletion: confirm
          )
          // TODO: make this navigation title white somehow?
            .navigationTitle(formattedSelection)
            .navigationBarTitleDisplayMode(.inline)
        } label: {
          if let confirmationTitleKey = confirmationTitleKey {
            Text(confirmationTitleKey)
          } else {
            Text("Continue", bundle: .module)
            // Text("\(newSelection)", bundle: .module)
          }
        }
      } else {
        Button(action: { confirm(newSelection) }) {
          if let confirmationTitleKey = confirmationTitleKey {
            Text(confirmationTitleKey)
          } else {
            Text("Done", bundle: .module)
          }
        }
      }
    }
    .buttonStyle(.borderedProminent)
    .foregroundStyle(.background)
    .tint(confirmationTint ?? .green)
  }
  
  private var componentPickers: some View {
    HStack {
      if showsMonthBeforeDay ?? locale.monthComesBeforeDay {
        monthPicker
        dayPicker
      } else {
        dayPicker
        monthPicker
      }
      yearPicker
    }
    .pickerStyle(.wheel)
    .textCase(.uppercase)
    // .minimumScaleFactor(0.5)
  }
  
  private var yearPicker: some View {
    Picker(selection: $year) {
      ForEach(yearRange, id: \.self) { year in
        Text(String(year))
          .minimumScaleFactor(0.5)
          .tag(year)
      }
    } label: {
      Text("Year", bundle: .module)
        .minimumScaleFactor(0.8)
    }
    // .overlay {
    //   RoundedRectangle(cornerRadius: 17, style: .continuous)
    //     .strokeBorder(.pink, lineWidth: 2)
    //     .padding(.top, 17)
    // }
    //.focusable()
  }
  
  private var monthPicker: some View {
    Picker(selection: $month) {
      ForEach(monthSymbols, id: \.offset) { offset, symbol in
        Text(symbol)
          .minimumScaleFactor(0.5)
          .tag(offset + 1)
      }
    } label: {
      Text("Month", bundle: .module)
        .minimumScaleFactor(0.8)
    }
    //.focusable()
  }
  
  private var dayPicker: some View {
    Picker(selection: $day) {
      ForEach(dayRange, id: \.self) { day in
        Text(String(day))
          .minimumScaleFactor(0.5)
          .tag(day)
      }
    } label: {
      Text("Day", bundle: .module)
        .minimumScaleFactor(0.8)
    }
    //.focusable()
    .id([month, year].map(String.init).joined(separator: "."))
    // FIXME: select lower day if month’s upper bound day range is less than selection’s day
    .onChange(of: month) { _ in
      if dayRange.upperBound < day {
//        print("!!! dayRange.upperBound < day")
        day = dayRange.upperBound
      }
    }
  }
}
