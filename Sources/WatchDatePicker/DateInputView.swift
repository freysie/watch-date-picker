#if os(watchOS)

import SwiftUI
import Combine

/// A control for the inputting of date values.
///
/// The `DateInputView` displays three pickers for month, day, and year, the order of which depends on locale. The view binds to a `Date` instance.
///
/// ![](DateInputView.png)
///
/// ![](DateInputView_fr.png)
@available(watchOS 8, *)
public struct DateInputView: View {
  private enum Field: Hashable { case month, day, year }

  @Binding private var underlyingSelection: Date?
  private var selection: Date { underlyingSelection ?? .nextHour }
  private var minimumDate: Date?
  private var maximumDate: Date?

  @State private var year = 0
  @State private var month = 0
  @State private var day = 0
  @State private var localeShowsMonthBeforeDay = false
  @FocusState private var focusedField: Field?

  private var selectionPublisher = PassthroughSubject<Void, Never>()

  @Environment(\.dateInputViewShowsMonthBeforeDay) private var showsMonthBeforeDay
  @Environment(\.dateInputViewTextCase) private var textCase
  @Environment(\.dateInputViewPickerBorderColor) private var pickerBorderColor
  @Environment(\.dateInputViewFocusTint) private var focusTint
  @Environment(\.locale) private var locale

  private var calendar: Calendar { locale.calendar }

  private let usesMonthSymbols = false

//  private var shouldUseMonthSymbols: Bool {
//    !calendar.shortStandaloneMonthSymbols.contains { $0.count > 4 }
//  }

  private var newSelection: Date {
    calendar.date(from: DateComponents(
      year: year,
      month: month,
      day: day,
      hour: calendar.component(.hour, from: selection),
      minute: calendar.component(.minute, from: selection)
    ))!
  }

  private var yearRange: Range<Int> {
    var lowerBound = calendar.component(.year, from: Date()) - 500
    var upperBound = calendar.component(.year, from: Date()) + 500

    if let minimumDate = minimumDate { lowerBound = calendar.component(.year, from: minimumDate) }
    if let maximumDate = maximumDate { upperBound = calendar.component(.year, from: maximumDate) }
    
    return lowerBound..<(upperBound + 1)
  }

  private var monthRange: Range<Int> {
    var lowerBound = 0
    var upperBound = calendar.monthSymbols.count

    if let minimumDate = minimumDate {
      let isSameYear = calendar.component(.year, from: minimumDate) == calendar.component(.year, from: selection)
      if isSameYear { lowerBound = calendar.component(.month, from: minimumDate) - 1 }
    }

    if let maximumDate = maximumDate {
      let isSameYear = calendar.component(.year, from: maximumDate) == calendar.component(.year, from: selection)
      if isSameYear { upperBound = calendar.component(.month, from: maximumDate) }
    }

    return lowerBound..<upperBound
  }

  private var monthSymbols: [EnumeratedSequence<[String]>.Element] {
    let symbols = Array(calendar.shortStandaloneMonthSymbols.enumerated())
    return Array(symbols[monthRange])
  }

  private var dayRange: Range<Int> {
    var range = calendar.range(of: .day, in: .month, for: newSelection)!

    if let minimumDate = minimumDate {
      let selectedYear = calendar.component(.year, from: minimumDate) == calendar.component(.year, from: selection)
      let selectedMonth = calendar.component(.month, from: minimumDate) == calendar.component(.month, from: selection)
      if selectedYear && selectedMonth { range = (calendar.component(.day, from: minimumDate) - 1)..<range.upperBound }
    }
    
    if let maximumDate = maximumDate {
      let selectedYear = calendar.component(.year, from: maximumDate) == calendar.component(.year, from: selection)
      let selectedMonth = calendar.component(.month, from: maximumDate) == calendar.component(.month, from: selection)
      if selectedYear && selectedMonth { range = range.lowerBound..<calendar.component(.day, from: maximumDate) }
    }
    
    return range
  }

  /// Creates a date input view instance with the specified properties.
  /// - Parameters:
  ///   - selection: The date value being displayed and selected.
  ///   - minimumDate: The oldest selectable date.
  ///   - maximumDate: The most recent selectable date.
  public init(
    selection: Binding<Date>,
    minimumDate: Date? = nil,
    maximumDate: Date? = nil
  ) {
    self.init(selection: Binding(selection), minimumDate: minimumDate, maximumDate: maximumDate)
  }

  /// Creates a date input view instance with the specified properties.
  /// - Parameters:
  ///   - selection: The optional date value being displayed and selected.
  ///   - minimumDate: The oldest selectable date.
  ///   - maximumDate: The most recent selectable date.
  public init(
    selection: Binding<Date?>,
    minimumDate: Date? = nil,
    maximumDate: Date? = nil
  ) {
    _underlyingSelection = selection

    self.minimumDate = minimumDate
    self.maximumDate = maximumDate

    _year = State(initialValue: Calendar.current.component(.year, from: self.selection))
    _month = State(initialValue: Calendar.current.component(.month, from: self.selection))
    _day = State(initialValue: Calendar.current.component(.day, from: self.selection))
  }

  /// The content and behavior of the view.
  public var body: some View {
    HStack(spacing: usesMonthSymbols ? 4 : 8) {
      if showsMonthBeforeDay ?? localeShowsMonthBeforeDay {
        monthPicker
        dayPicker
      } else {
        dayPicker
        monthPicker
      }
      yearPicker
    }
    .accessibilityElement(children: isTakingScreenshots ? .contain : .ignore)
    .pickerStyle(.wheel)
    .font(usesMonthSymbols ? .caption : .system(size: .pickerFontSize))
    .textCase(textCase)
    .padding(.horizontal, 0.5)
    .padding(.vertical, 5)
    .frame(height: .dateInputHeight)
    .onChange(of: year) { _ in selectionPublisher.send() }
    .onChange(of: month) { _ in selectionPublisher.send() }
    .onChange(of: day) { _ in selectionPublisher.send() }
    .onReceive(selectionPublisher.debounce(for: 0.15, scheduler: RunLoop.main)) { _ in
      underlyingSelection = newSelection
    }
    .onAppear {
      localeShowsMonthBeforeDay = locale.showsMonthBeforeDay
    }
  }

  private var yearPicker: some View {
    Picker(selection: $year) {
      ForEach(yearRange, id: \.self) { year in
        Text(year, format: .number.grouping(.never))
          .tag(year)
      }
    } label: {
      Text("Year", bundle: .module)
        .minimumScaleFactor(.pickerLabelMinimumScaleFactor)
    }
    .accessibilityIdentifier("YearPicker")
    .focused($focusedField, equals: .year)
    .overlay { pickerBorder(isFocused: focusedField == .year) }
    .frame(width: usesMonthSymbols ? .infinity : WKInterfaceDevice.current().screenBounds.width * 0.39)
  }

  private var monthPicker: some View {
    Picker(selection: $month) {
      if usesMonthSymbols {
        ForEach(monthSymbols, id: \.offset) { offset, symbol in
          Text(symbol)
            .tag(offset + 1)
        }
      } else {
        ForEach(monthRange, id: \.self) { month in
          Text(month + 1, format: .number)
            .tag(month + 1)
        }
      }
    } label: {
      Text("Month", bundle: .module)
        .minimumScaleFactor(.pickerLabelMinimumScaleFactor)
        .padding(.horizontal, -8)
    }
    .accessibilityIdentifier("MonthPicker")
    .focused($focusedField, equals: .month)
    .overlay { pickerBorder(isFocused: focusedField == .month) }
  }

  private var dayPicker: some View {
    Picker(selection: $day) {
      ForEach(dayRange, id: \.self) { day in
        Text(day, format: .number)
          .tag(day)
      }
    } label: {
      Text("Day", bundle: .module)
        .minimumScaleFactor(.pickerLabelMinimumScaleFactor)
    }
    .accessibilityIdentifier("DayPicker")
    .focused($focusedField, equals: .day)
    .overlay { pickerBorder(isFocused: focusedField == .day) }
    // FIXME: select lower day if month’s upper bound day range is less than selection’s day, but it’s not working, aaaaaaaaaaa
    .id([month, year].map(String.init).joined(separator: "."))
    //.onChange(of: month) { _ in
    .onReceive(selectionPublisher.debounce(for: 0.15, scheduler: RunLoop.main)) { _ in
      //NSLog("[WatchDatePicker] \(dayRange.upperBound - 1) <= \(day) = \(dayRange.upperBound - 1 <= day)")
      if dayRange.upperBound - 1 <= day {
        //NSLog("[WatchDatePicker] dayRange.upperBound - 1 <= day")
        //DispatchQueue.main.async {
          //DispatchQueue.main.async {
            day = dayRange.upperBound - 1
          //}
        //}
      }
    }
  }
  
  @ViewBuilder private func pickerBorder(isFocused: Bool = true) -> some View {
    if focusTint != nil || pickerBorderColor != nil {
      ZStack {
        RoundedRectangle(cornerRadius: .pickerCornerRadius * 2, style: .continuous)
          .strokeBorder(.black, lineWidth: 5)
          .padding(.top, 14.5)
          .padding(.horizontal, -0.5)
          .padding(-3)

        RoundedRectangle(cornerRadius: .pickerCornerRadius, style: .continuous)
          .strokeBorder(
            isFocused ? focusTint ?? .white : pickerBorderColor ?? .gray,
            lineWidth: isFocused ? 1.5 : 1
          )
          .animation(.linear, value: isFocused)
          .padding(.top, 14.5)
          .padding(.horizontal, -0.5)
      }
    } else {
      EmptyView()
    }
  }
}

struct DateInputView_Previews: PreviewProvider {
  // TODO: move to a new view type that can be used both here and in `DatePicker`
  struct Example: View {
    @State var date = Calendar.current.date(bySettingHour: 10, minute: 09, second: 0, of: Date())!
    @Environment(\.datePickerConfirmationTint) var confirmationTint

    var body: some View {
      VStack(spacing: 10) {
        DateInputView(selection: $date)

        circularButtons
          .padding(.bottom, -21)
      }
      .frame(maxHeight: .infinity)
      .edgesIgnoringSafeArea(.all)
      .navigationBarHidden(true)
      .watchStatusBar(hidden: true)
    }

    private var circularButtons: some View {
      HStack {
        Button(action: {}) {
          Image(systemName: "xmark")
        }
        .accessibilityLabel(Text("Cancel", bundle: .module))
        .accessibilityIdentifier("CancelButton")
        .buttonStyle(.circular(.gray))

        Spacer()

        Button(action: {}) {
          Image(systemName: "checkmark")
        }
        .accessibilityLabel(Text("Done", bundle: .module))
        .accessibilityIdentifier("DoneButton")
        .accessibilityRemoveTraits(.isSelected)
        .buttonStyle(.circular(confirmationTint ?? .green))
      }
      .padding(.horizontal, 12)
    }
  }

  static var previews: some View {
    Group {
      Example()
        .previewDisplayName("Default")

      Example()
        .dateInputViewShowsMonthBeforeDay(false)
        .previewDisplayName("Day First")

      Group {
        Example()
          .environment(\.locale, Locale(identifier: "fi"))
          .previewDisplayName("Finnish")

        Example()
          .environment(\.locale, Locale(identifier: "fr"))
          .previewDisplayName("French")

        Example()
          .environment(\.locale, Locale(identifier: "ru"))
          .previewDisplayName("Russian")

        Example()
          .environment(\.locale, Locale(identifier: "sv"))
          .previewDisplayName("Swedish")

        Example()
          .environment(\.locale, Locale(identifier: "ar"))
          .environment(\.layoutDirection, .rightToLeft)
          .previewDisplayName("Arabic")

        Example()
          .environment(\.locale, Locale(identifier: "de"))
          .previewDisplayName("German")

        Example()
          .environment(\.locale, Locale(identifier: "he"))
          .environment(\.layoutDirection, .rightToLeft)
          .previewDisplayName("Hebrew")
      }

      Example()
        .tint(.pink)
        .previewDisplayName("Pink")

#if swift(>=5.7)
      Group {
        if #available(watchOS 9.1, *) {
          Example()
            .fontDesign(.serif)
            .tint(.brown)
            .previewDisplayName("Serif")
        }

        if #available(watchOS 9.1, *) {
          Example()
            .fontDesign(.monospaced)
            .tint(.green)
            .previewDisplayName("Monospaced")
        }

        if #available(watchOS 9.1, *) {
          Example()
            .fontDesign(.rounded)
            .tint(.purple)
            .previewDisplayName("Rounded")
        }
      }
#endif
    }
    .tint(.orange)
  }
}

#endif
