import SwiftUI

// FIXME: use `locale.calendar` instead of `Calendar.current` throughout as to support non-Gregorian calendars etc.

public struct DatePickerView: View {
  @Binding public var selection: Date
  public var mode: DatePicker.Mode?
  public var minimumDate: Date?
  public var maximumDate: Date?
  public var showsMonthBeforeDay: Bool?
  public var twentyFourHour: Bool?
  public var confirmationTitleKey: LocalizedStringKey?
  public var confirmationColor: Color?
  public var onCompletion: ((Date) -> Void)?
  
  @State private var year = 0
  @State private var month = 0
  @State private var day = 0
  
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
    let thisYear = locale.calendar.component(.year, from: Date())
    // TODO: make this infinity
    var lowerBound = thisYear - 100
    var upperBound = thisYear + 100
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
    showsMonthBeforeDay: Bool? = nil,
    twentyFourHour: Bool = false,
    confirmationTitleKey: LocalizedStringKey? = nil,
    confirmationColor: Color? = nil,
    onCompletion: ((Date) -> Void)? = nil
  ) {
    _selection = selection
    self.mode = mode
    self.minimumDate = minimumDate
    self.maximumDate = maximumDate
    self.showsMonthBeforeDay = showsMonthBeforeDay
    self.twentyFourHour = twentyFourHour
    self.confirmationTitleKey = confirmationTitleKey
    self.confirmationColor = confirmationColor
    self.onCompletion = onCompletion
    _year = State(initialValue: locale.calendar.component(.year, from: self.selection))
    _month = State(initialValue: locale.calendar.component(.month, from: self.selection))
    _day = State(initialValue: locale.calendar.component(.day, from: self.selection))
  }
  
  public var body: some View {
    if let mode = mode, mode == .time {
      TimePickerView(
        selection: $selection,
        mode: mode,
        twentyFourHour: twentyFourHour,
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
        NavigationLink(confirmationTitleKey ?? "Continue") {
          TimePickerView(
            selection: .constant(newSelection),
            mode: mode,
            twentyFourHour: twentyFourHour,
            onCompletion: confirm
          )
          // TODO: make this navigation title white somehow?
            .navigationTitle(formattedSelection)
            .navigationBarTitleDisplayMode(.inline)
        }
      } else {
        Button(confirmationTitleKey ?? "Done", action: { confirm(newSelection) })
      }
    }
    .buttonStyle(.borderedProminent)
    .foregroundStyle(.background)
    .tint(confirmationColor ?? .green)
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
    .minimumScaleFactor(0.5)
  }
  
  private var yearPicker: some View {
    Picker("Year", selection: $year) {
      ForEach(yearRange) { year in
        Text(String(year))
          .tag(year)
      }
    }
    //.focusable()
  }
  
  private var monthPicker: some View {
    Picker("Month", selection: $month) {
      ForEach(monthSymbols, id: \.offset) { offset, symbol in
        Text(symbol)
          .tag(offset + 1)
      }
    }
    //.focusable()
  }
  
  private var dayPicker: some View {
    Picker("Day", selection: $day) {
      ForEach(dayRange) { day in
        Text(String(day))
          .tag(day)
      }
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
  
