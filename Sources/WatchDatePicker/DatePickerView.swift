import SwiftUI
import WatchKit

// FIXME: use `locale.calendar` instead of `Calendar.current` throughout as to support non-Gregorian calendars etc.
fileprivate let now = Date()
fileprivate let thisYear = Calendar.current.component(.year, from: now)

// TODO: add public init
public struct DatePickerView: View {
  public var mode: DatePicker.Mode?
  public var minimumDate: Date?
  public var maximumDate: Date?
  public var showsMonthBeforeDay: Bool?
  public var twentyFourHour: Bool = false
  public var confirmationTitleKey: LocalizedStringKey? = nil
  public var confirmationColor: Color? = nil
  public var onCompletion: ((Date) -> Void)?
  
  @State private var year = thisYear
  // FIXME: select lower day if month’s upper bound day range is less than selection’s day
  @State private var month = Calendar.current.component(.month, from: now)
  @State private var day = Calendar.current.component(.day, from: now)
  
  @Environment(\.locale) private var locale
  @Environment(\.dismiss) private var dismiss
  
  private func _onCompletion(_ date: Date) {
    if mode == .date { dismiss() }
    onCompletion?(date)
  }
  
  private var selection: Date {
    locale.calendar.date(from: DateComponents(year: year, month: month, day: day))!
  }
  
  private var formattedSelection: String {
    let formatter = DateFormatter()
    formatter.locale = locale
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    return formatter.string(from: selection)
  }
  
  private var yearRange: Range<Int> {
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
    locale.calendar.range(of: .day, in: .month, for: selection)!
  }
  
  public var body: some View {
    if let mode = mode, mode == .time {
      TimePickerView(mode: mode, twentyFourHour: twentyFourHour, onCompletion: _onCompletion)
    } else {
      VStack(spacing: 10) {
        componentPickers
        
        if mode != nil {
          confirmationAction
        }
      }
      .toolbar {
        ToolbarItem(placement: .confirmationAction) {
          Button("", action: {}).foregroundColor(.clear)
        }
      }
    }
  }
  
  private var confirmationAction: some View {
    Group {
      if let mode = mode, mode == .dateAndTime {
        // Button("Continue", action: { timePickerIsPresented = true })
        NavigationLink(confirmationTitleKey ?? "Continue") {
          TimePickerView(date: selection, mode: mode, twentyFourHour: twentyFourHour, onCompletion: _onCompletion)
          // TODO: make this navigation title white somehow?
            .navigationTitle(formattedSelection)
            .navigationBarTitleDisplayMode(.inline)
        }
      } else {
        Button(confirmationTitleKey ?? "Done", action: { _onCompletion(selection) })
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
      ForEach(monthSymbols, id: \.offset) { month, symbol in
        Text(symbol)
          .tag(month)
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
    .onChange(of: month) { _ in
      if dayRange.upperBound < day {
        print("!!! dayRange.upperBound < day")
        day = dayRange.upperBound
      }
    }
  }
}
