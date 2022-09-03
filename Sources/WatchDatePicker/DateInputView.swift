import SwiftUI

/// A control for the inputting of date values.
///
/// The `DateInputView` displays three pickers for month, day, and year, the order of which depends on locale. The view binds to a `Date` instance.
///
/// ![](DateInputView.png)
/// ![](DateInputView~fr.png)
@available(watchOS 8, *)
@available(macOS, unavailable)
@available(iOS, unavailable)
@available(tvOS, unavailable)
public struct DateInputView: View {
  enum Field: Hashable { case month, day, year }

  @Binding var selection: Date
  var minimumDate: Date?
  var maximumDate: Date?

  @State private var year = 0
  @State private var month = 0
  @State private var day = 0
  @FocusState private var focusedField: Field?

  @Environment(\.dateInputViewShowsMonthBeforeDay) private var showsMonthBeforeDay
  @Environment(\.dateInputViewTextCase) private var textCase
  @Environment(\.locale) private var locale

  private var newSelection: Date {
    locale.calendar.date(from: DateComponents(
      year: year,
      month: month,
      day: day,
      hour: locale.calendar.component(.hour, from: selection),
      minute: locale.calendar.component(.minute, from: selection)
    ))!
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
    let symbols = Array(locale.calendar.shortMonthSymbols.enumerated())
    var lowerBound = 0
    var upperBound = symbols.count
    if let minimumDate = minimumDate {
      if locale.calendar.component(.year, from: minimumDate) == locale.calendar.component(.year, from: selection) {
        lowerBound = locale.calendar.component(.month, from: minimumDate) - 1
      }
    }
    if let maximumDate = maximumDate {
      if locale.calendar.component(.year, from: maximumDate) == locale.calendar.component(.year, from: selection) {
        upperBound = locale.calendar.component(.month, from: maximumDate)
      }
    }
    return Array(symbols[lowerBound..<upperBound])
  }

  // TODO: add minimumDate/maximumDate constraints
  private var dayRange: Range<Int> {
    locale.calendar.range(of: .day, in: .month, for: newSelection)!
  }

  public init(
    selection: Binding<Date>,
    minimumDate: Date? = nil,
    maximumDate: Date? = nil
  ) {
    _selection = selection

    self.minimumDate = minimumDate
    self.maximumDate = maximumDate

    _year = State(initialValue: locale.calendar.component(.year, from: self.selection))
    _month = State(initialValue: locale.calendar.component(.month, from: self.selection))
    _day = State(initialValue: locale.calendar.component(.day, from: self.selection))
  }

  /// The content and behavior of the view.
  public var body: some View {
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
    .textCase(textCase)
    // .padding(.horizontal, 10)
    .scenePadding(.horizontal)
    .padding(.vertical, 5)
    // .minimumScaleFactor(0.5)
    .onChange(of: newSelection) { selection = $0 }
  }

//  private var confirmationAction: some View {
//    Group {
//      if let mode = mode, mode == .dateAndTime {
//        NavigationLink {
//          TimeInputView(
//            selection: .constant(newSelection),
//            mode: mode,
//            onCompletion: confirm
//          )
//          // TODO: make this navigation title white somehow?
//            .navigationTitle(formattedSelection)
//            .navigationBarTitleDisplayMode(.inline)
//        } label: {
//          if let confirmationTitleKey = confirmationTitleKey {
//            Text(confirmationTitleKey)
//          } else {
//            Text("Continue", bundle: .module)
//            // Text("\(newSelection)", bundle: .module)
//          }
//        }
//      } else {
//        Button(action: { confirm(newSelection) }) {
//          if let confirmationTitleKey = confirmationTitleKey {
//            Text(confirmationTitleKey)
//          } else {
//            Text("Done", bundle: .module)
//          }
//        }
//      }
//    }
//    .buttonStyle(.borderedProminent)
//    .foregroundStyle(.background)
//    .tint(confirmationTint ?? .green)
//  }

  private var labelMinimumScaleFactor: Double {
    switch WKInterfaceDevice.current().screenBounds.width {
    case 176, 198: return 0.8 // 41 mm, 45 mm
    default: return 1
    }
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
        .minimumScaleFactor(labelMinimumScaleFactor)
    }
    .focused($focusedField, equals: .year)
    .overlay { tintedPickerBorder(focused: focusedField == .year) }
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
        .minimumScaleFactor(labelMinimumScaleFactor)
    }
    .focused($focusedField, equals: .month)
    .overlay { tintedPickerBorder(focused: focusedField == .month) }
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
        .minimumScaleFactor(labelMinimumScaleFactor)
    }
    .focused($focusedField, equals: .day)
    .overlay { tintedPickerBorder(focused: focusedField == .day) }
    // .id([month, year].map(String.init).joined(separator: "."))
    // FIXME: select lower day if month’s upper bound day range is less than selection’s day
    // .onChange(of: month) { _ in
    //   NSLog("[WatchDatePicker] \(dayRange.upperBound - 1) <= \(day) = \(dayRange.upperBound - 1 <= day)")
    //   if dayRange.upperBound - 1 <= day {
    //     NSLog("[WatchDatePicker] dayRange.upperBound - 1 <= day")
    //     DispatchQueue.main.async {
    //       DispatchQueue.main.async {
    //         day = dayRange.upperBound - 1
    //       }
    //     }
    //   }
    // }
  }
  
  private func tintedPickerBorder(focused: Bool = true) -> some View {
    EmptyView()
    // RoundedRectangle(cornerRadius: 11, style: .continuous)
    //   .strokeBorder(!focused ? .white : .indigo, lineWidth: !focused ? 1.5 : 2)
    //   .padding(.top, 16.5)
    //   // .padding(.bottom, -0.5)
    //   .animation(.linear, value: focused)
    //   // .transition(.opacity)
  }
}

@available(macOS, unavailable)
@available(iOS, unavailable)
@available(tvOS, unavailable)
struct DateInputView_Previews: PreviewProvider {
  static var previews: some View {
    DateInputView(selection: .constant(Date()))
      .previewDisplayName("Default")
    
    DateInputView(selection: .constant(Date()))
      .dateInputViewShowsMonthBeforeDay(false)
      .previewDisplayName("Day First")
    
    DateInputView(selection: .constant(Date()))
      .environment(\.locale, Locale(identifier: "fr"))
      .previewDisplayName("French")
    
    DateInputView(selection: .constant(Date()))
      .environment(\.locale, Locale(identifier: "da"))
      .previewDisplayName("Danish")
  }
}
