import SwiftUI

// TODO: determine `timeInputViewTwentyFourHour` automatically based on locale
// TODO: determine the exact differences (if any) between `sheet()` and `fullScreenCover()` in watchOS

/// Option set that determines the displayed components of a date picker.
///
/// Specifying ``date`` displays month, day, and year depending on the locale setting:
/// ![](DateMode.png)
/// Specifying ``hourAndMinute`` displays hour, minute, and optionally AM/PM designation depending on the locale setting:
/// ![](TimeMode.png)
/// Specifying both ``date`` and ``hourAndMinute`` displays date, hour, minute, and optionally AM/PM designation depending on the locale setting, inside of a navigation view:
/// ![](DateAndTimeMode.png)
public struct DatePickerComponents: OptionSet {
  public let rawValue: UInt
  public init(rawValue: UInt) { self.rawValue = rawValue }
  
  /// Displays day, month, and year based on the locale.
  public static let date = Self(rawValue: 1 << 0)
  
  /// Displays hour and minute components based on the locale.
  public static let hourAndMinute = Self(rawValue: 1 << 1)
}

///// Enum that determines the display mode of a date picker.
//public enum DatePickerDisplayMode {
//  case navigationStack
//  case sheets
//  case sheetAndNavigationStack
//}

/// A control for the inputting of date and time values.
///
/// The `DatePicker` view displays a button with a title and the selected value. When pressed, it presents a sheet with user interface for selecting date, time, or both. The view binds to a `Date` instance.
///
/// ![](DateAndTimeMode.png)
@available(watchOS 8, *)
@available(macOS, unavailable)
@available(iOS, unavailable)
@available(tvOS, unavailable)
public struct DatePicker<Label: View>: View {
  public typealias Components = DatePickerComponents

  @ViewBuilder var label: Label
  @Binding var selection: Date
  let displayedComponents: Components

  @State private var newSelection: Date
  private var minimumDate: Date?
  private var maximumDate: Date?
  private var dateStyle: DateFormatter.Style = .medium
  private var timeStyle: DateFormatter.Style = .short

  @State private var sheetIsPresented = false
  @State private var navigationLinkIsActive = false

  @Environment(\.locale) private var locale

  @Environment(\.datePickerFlipsLabelAndValue) private var flipsLabelAndValue
  @Environment(\.timeInputViewTwentyFourHour) private var twentyFourHour

  private var formattedButtonTitle: String {
    // TODO: don’t recreate the formatter every time? (profile this or ask on Discord)
    let formatter = DateFormatter()
    formatter.locale = locale
    
    switch displayedComponents {
    case [.date, .hourAndMinute]:
      formatter.dateStyle = .short
      formatter.timeStyle = .short
      
    case .date:
      // formatter.dateFormat = "Tue, Aug 2, 2022"
      formatter.dateStyle = .medium
      formatter.timeStyle = .none
      
    case .hourAndMinute:
      formatter.dateStyle = .none
      formatter.timeStyle = .short
      
    default:
      break
    }
    
    // if twentyFourHour == true && displayedComponents == .hourAndMinute {
    //   formatter.dateFormat = "HH:mm"
    // }
    
    return formatter.string(from: selection)
  }

  private var formattedNavigationTitle: String {
    // TODO: don’t recreate the formatter every time? (profile this or ask on Discord)
    let formatter = DateFormatter()
    formatter.locale = locale
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    return formatter.string(from: newSelection)
  }

  private var confirmationButton: some View {
    Button(action: { navigationLinkIsActive = true }) {
      Text("Continue", bundle: .module)
    }
    .buttonStyle(.borderedProminent)
    .foregroundStyle(.background)
    .tint(.green)
    .padding()
    // .scenePadding(.horizontal)
  }
  
  private var circularButtons: some View {
    HStack {
      Button(action: { sheetIsPresented = false }) {
        Image(systemName: "xmark")
      }
      .buttonStyle(.circular(.gray))
      
      Spacer()
      
      Button(action: submit) {
        Image(systemName: "checkmark")
      }
      .buttonStyle(.circular(.green))
    }
    .padding(.horizontal, 12)
  }

  private func submit() {
    sheetIsPresented = false
    selection = newSelection

    if navigationLinkIsActive {
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
        navigationLinkIsActive = false
      }
    }
  }

  /// The content and behavior of the view.
  public var body: some View {
    Button(action: { sheetIsPresented = true }) {
      VStack(alignment: .leading) {
        // TODO: consider if this can be achieved in a cleaner and more reusable way
        if flipsLabelAndValue != true {
          label
          
          Text(formattedButtonTitle)
            .font(.footnote)
            .foregroundStyle(.secondary)
        } else {
          Text(formattedButtonTitle)

          label
            .font(.footnote)
            .foregroundStyle(.secondary)
        }
      }
    }
    .onChange(of: sheetIsPresented) { isPresented in
      // print("sheetIsPresented = \(isPresented)")
      // if !isPresented { newSelection = selection }
      newSelection = selection
    }
    .sheet(isPresented: $sheetIsPresented) {
      Group {
        switch displayedComponents {
        case [.date, .hourAndMinute]:
          NavigationView {
            VStack {
              DateInputView(selection: $newSelection, minimumDate: minimumDate, maximumDate: maximumDate)
                .overlay {
                  NavigationLink(isActive: $navigationLinkIsActive) {
                    TimeInputView(selection: $newSelection)
                      .navigationTitle(formattedNavigationTitle)
                      .navigationBarTitleDisplayMode(.inline)
                      .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                          Button("Done", action: submit)
                        }
                      }
                  } label: {
                    EmptyView()
                  }
                  .hidden()
                }
              
              confirmationButton
            }
            // .watchStatusBar(hidden: true)
            .edgesIgnoringSafeArea(.bottom)
            // .padding(.bottom)
            // .edgesIgnoringSafeArea([.bottom, .leading, .trailing])
            .scenePadding(.bottom)
          }
          
        case .date:
          VStack(spacing: 15) {
            Spacer()
            
            DateInputView(selection: $newSelection, minimumDate: minimumDate, maximumDate: maximumDate)
              .frame(minHeight: 120)
              .padding(.top, 20)
            
            circularButtons
          }
          .frame(maxHeight: .infinity)
          .navigationBarHidden(true)
          // .watchStatusBar(hidden: true)
          // .border(.mint)
          .edgesIgnoringSafeArea(.all)
          // .border(.pink)
          .padding(.bottom, -20)
          // .border(.brown)
          
        case .hourAndMinute:
          ZStack(alignment: .bottom) {
            TimeInputView(selection: $newSelection)
            
            circularButtons
              .padding(.bottom, -26)
              .padding(.horizontal, 32)
          }
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .navigationBarHidden(true)
          ._statusBar(hidden: true)
          // .watchStatusBar(hidden: true)
          .toolbar {
            ToolbarItem(placement: .confirmationAction) {
              Button("", action: {})
                .accessibilityHidden(true)
            }
          }
          .edgesIgnoringSafeArea(.all)
          .padding(.bottom, -40)
          .padding(.horizontal, -32)
          .offset(y: -45)
          
        default:
          EmptyView()
        }
      }
      // .onAppear {
      //   print("onAppear")
      //   // newSelection = selection
      // }
      // .onDisappear {
      //   print("onDisappear")
      //   // newSelection = selection
      // }
    }
  }
}

@available(watchOS 8, *)
@available(macOS, unavailable)
@available(iOS, unavailable)
@available(tvOS, unavailable)
extension View {
  func watchStatusBar(hidden: Bool) -> some View {
    toolbar {
      ToolbarItem(placement: .confirmationAction) {
        Button("", action: {})
          .accessibilityHidden(true)
      }
    }
  }
}

@available(watchOS 8, *)
@available(macOS, unavailable)
@available(iOS, unavailable)
@available(tvOS, unavailable)
extension DatePicker {
  /// Creates an instance that selects a `Date` with an unbounded range.
  ///
  /// - Parameters:
  ///   - selection: The date value being displayed and selected.
  ///   - displayedComponents: The date components that user is able to view and edit. Defaults to `[.date, .hourAndMinute]`.
  ///   - label: A view that describes the use of the date.
  public init(
    selection: Binding<Date>,
    displayedComponents: Components = [.date, .hourAndMinute],
    label: () -> Label
  ) {
    _selection = selection
    _newSelection = State(initialValue: selection.wrappedValue)
    self.displayedComponents = displayedComponents
    self.label = label()
  }

  /// Creates an instance that selects a `Date` in a closed range.
  ///
  /// Only selection of day, month, and year, not hour and minute, will adhere to the range.
  ///
  /// - Parameters:
  ///   - selection: The date value being displayed and selected.
  ///   - range: The inclusive range of selectable dates.
  ///   - displayedComponents: The date components that user is able to view and edit. Defaults to `[.date, .hourAndMinute]`.
  ///   - label: A view that describes the use of the date.
  public init(
    selection: Binding<Date>,
    in range: ClosedRange<Date>,
    displayedComponents: Components = [.date, .hourAndMinute],
    label: () -> Label
  ) {
    _selection = selection
    _newSelection = State(initialValue: selection.wrappedValue)
    minimumDate = range.lowerBound
    maximumDate = range.upperBound
    self.displayedComponents = displayedComponents
    self.label = label()
  }

  /// Creates an instance that selects a `Date` on or after some start date.
  ///
  /// Only selection of day, month, and year, not hour and minute, will adhere to the range.
  ///
  /// - Parameters:
  ///   - selection: The date value being displayed and selected.
  ///   - range: The open range from some selectable start date.
  ///   - displayedComponents: The date components that user is able to view and edit. Defaults to `[.date, .hourAndMinute]`.
  ///   - label: A view that describes the use of the date.
  public init(
    selection: Binding<Date>,
    in range: PartialRangeFrom<Date>,
    displayedComponents: Components = [.date, .hourAndMinute],
    label: () -> Label
  ) {
    _selection = selection
    _newSelection = State(initialValue: selection.wrappedValue)
    minimumDate = range.lowerBound
    self.displayedComponents = displayedComponents
    self.label = label()
  }

  /// Creates an instance that selects a `Date` on or before some end date.
  ///
  /// Only selection of day, month, and year, not hour and minute, will adhere to the range.
  ///
  /// - Parameters:
  ///   - selection: The date value being displayed and selected.
  ///   - range: The open range before some selectable end date.
  ///   - displayedComponents: The date components that user is able to view and edit. Defaults to `[.date, .hourAndMinute]`.
  ///   - label: A view that describes the use of the date.
  public init(
    selection: Binding<Date>,
    in range: PartialRangeThrough<Date>,
    displayedComponents: Components = [.date, .hourAndMinute],
    label: () -> Label
  ) {
    _selection = selection
    _newSelection = State(initialValue: selection.wrappedValue)
    maximumDate = range.upperBound
    self.displayedComponents = displayedComponents
    self.label = label()
  }
}

@available(watchOS 8, *)
@available(macOS, unavailable)
@available(iOS, unavailable)
@available(tvOS, unavailable)
extension DatePicker where Label == Text {
  /// Creates an instance that selects a `Date` with an unbounded range.
  ///
  /// - Parameters:
  ///   - label: The key for the localized title of `self`, describing its purpose.
  ///   - selection: The date value being displayed and selected.
  ///   - displayedComponents: The date components that user is able to view and edit. Defaults to `[.date, .hourAndMinute]`.
  public init(
    _ titleKey: LocalizedStringKey,
    selection: Binding<Date>,
    displayedComponents: Components = [.date, .hourAndMinute]
  ) {
    label = Text(titleKey)
    _selection = selection
    _newSelection = State(initialValue: selection.wrappedValue)
    self.displayedComponents = displayedComponents
  }
  
  /// Creates an instance that selects a `Date` in a closed range.
  ///
  /// Only selection of day, month, and year, not hour and minute, will adhere to the range.
  ///
  /// - Parameters:
  ///   - label: The key for the localized title of `self`, describing its purpose.
  ///   - selection: The date value being displayed and selected.
  ///   - range: The inclusive range of selectable dates.
  ///   - displayedComponents: The date components that user is able to view and edit. Defaults to `[.date, .hourAndMinute]`.
  public init(
    _ titleKey: LocalizedStringKey,
    selection: Binding<Date>,
    in range: ClosedRange<Date>,
    displayedComponents: Components = [.date, .hourAndMinute]
  ) {
    label = Text(titleKey)
    _selection = selection
    _newSelection = State(initialValue: selection.wrappedValue)
    minimumDate = range.lowerBound
    maximumDate = range.upperBound
    self.displayedComponents = displayedComponents
  }
  
  /// Creates an instance that selects a `Date` on or after some start date.
  ///
  /// Only selection of day, month, and year, not hour and minute, will adhere to the range.
  ///
  /// - Parameters:
  ///   - label: The key for the localized title of `self`, describing its purpose.
  ///   - selection: The date value being displayed and selected.
  ///   - range: The open range from some selectable start date.
  ///   - displayedComponents: The date components that user is able to view and edit. Defaults to `[.date, .hourAndMinute]`.
  public init(
    _ titleKey: LocalizedStringKey,
    selection: Binding<Date>,
    in range: PartialRangeFrom<Date>,
    displayedComponents: Components = [.date, .hourAndMinute]
  ) {
    label = Text(titleKey)
    _selection = selection
    _newSelection = State(initialValue: selection.wrappedValue)
    minimumDate = range.lowerBound
    self.displayedComponents = displayedComponents
  }
  
  /// Creates an instance that selects a `Date` on or before some end date.
  ///
  /// Only selection of day, month, and year, not hour and minute, will adhere to the range.
  ///
  /// - Parameters:
  ///   - label: The key for the localized title of `self`, describing its purpose.
  ///   - selection: The date value being displayed and selected.
  ///   - range: The open range before some selectable end date.
  ///   - displayedComponents: The date components that user is able to view and edit. Defaults to `[.date, .hourAndMinute]`.
  public init(
    _ titleKey: LocalizedStringKey,
    selection: Binding<Date>,
    in range: PartialRangeThrough<Date>,
    displayedComponents: Components = [.date, .hourAndMinute]
  ) {
    label = Text(titleKey)
    _selection = selection
    _newSelection = State(initialValue: selection.wrappedValue)
    maximumDate = range.upperBound
    self.displayedComponents = displayedComponents
  }
}

@available(watchOS 8, *)
@available(macOS, unavailable)
@available(iOS, unavailable)
@available(tvOS, unavailable)
extension DatePicker where Label == Text {
  /// Creates an instance that selects a `Date` with an unbounded range.
  ///
  /// - Parameters:
  ///   - label: The title of self, describing its purpose.
  ///   - selection: The date value being displayed and selected.
  ///   - displayedComponents: The date components that user is able to view and edit. Defaults to `[.date, .hourAndMinute]`.
  public init<S: StringProtocol>(
    _ title: S,
    selection: Binding<Date>,
    displayedComponents: Components = [.date, .hourAndMinute]
  ) {
    label = Text(title)
    _selection = selection
    _newSelection = State(initialValue: selection.wrappedValue)
    self.displayedComponents = displayedComponents
  }
  
  /// Creates an instance that selects a `Date` in a closed range.
  ///
  /// Only selection of day, month, and year, not hour and minute, will adhere to the range.
  ///
  /// - Parameters:
  ///   - label: The title of self, describing its purpose.
  ///   - selection: The date value being displayed and selected.
  ///   - range: The inclusive range of selectable dates.
  ///   - displayedComponents: The date components that user is able to view and edit. Defaults to `[.date, .hourAndMinute]`.
  public init<S: StringProtocol>(
    _ title: S,
    selection: Binding<Date>,
    in range: ClosedRange<Date>,
    displayedComponents: Components = [.date, .hourAndMinute]
  ) {
    label = Text(title)
    _selection = selection
    _newSelection = State(initialValue: selection.wrappedValue)
    minimumDate = range.lowerBound
    maximumDate = range.upperBound
    self.displayedComponents = displayedComponents
  }
  
  /// Creates an instance that selects a `Date` on or after some start date.
  ///
  /// Only selection of day, month, and year, not hour and minute, will adhere to the range.
  ///
  /// - Parameters:
  ///   - label: The title of self, describing its purpose.
  ///   - selection: The date value being displayed and selected.
  ///   - range: The open range from some selectable start date.
  ///   - displayedComponents: The date components that user is able to view and edit. Defaults to `[.date, .hourAndMinute]`.
  public init<S: StringProtocol>(
    _ title: S,
    selection: Binding<Date>,
    in range: PartialRangeFrom<Date>,
    displayedComponents: Components = [.date, .hourAndMinute]
  ) {
    label = Text(title)
    _selection = selection
    _newSelection = State(initialValue: selection.wrappedValue)
    minimumDate = range.lowerBound
    self.displayedComponents = displayedComponents
  }
  
  /// Creates an instance that selects a `Date` on or before some end date.
  ///
  /// Only selection of day, month, and year, not hour and minute, will adhere to the range.
  ///
  /// - Parameters:
  ///   - label: The title of self, describing its purpose.
  ///   - selection: The date value being displayed and selected.
  ///   - range: The open range before some selectable end date.
  ///   - displayedComponents: The date components that user is able to view and edit. Defaults to `[.date, .hourAndMinute]`.
  public init<S: StringProtocol>(
    _ title: S,
    selection: Binding<Date>,
    in range: PartialRangeThrough<Date>,
    displayedComponents: Components = [.date, .hourAndMinute]
  ) {
    label = Text(title)
    _selection = selection
    _newSelection = State(initialValue: selection.wrappedValue)
    maximumDate = range.upperBound
    self.displayedComponents = displayedComponents
  }
}

@available(macOS, unavailable)
@available(iOS, unavailable)
@available(tvOS, unavailable)
struct DatePicker_Previews: PreviewProvider {
  struct Example: View {
    @State var value = Calendar.current.date(bySettingHour: 10, minute: 09, second: 0, of: Date())!
    
    var body: some View {
      Form {
        DatePicker("Select Date & Time", selection: $value)
        DatePicker("Select Date", selection: $value, displayedComponents: .date)
        DatePicker("Select Time", selection: $value, displayedComponents: .hourAndMinute)

        DatePicker(selection: $value) {
          Label("Select Date & Time", systemImage: "clock")
        }

        DatePicker(String("Select Date & Time"), selection: $value)
      }
      .tint(.orange)
    }
  }

  static var previews: some View {
    NavigationView {
      Example()
    }
    
//    NavigationView {
//      TimeInputView(selection: .constant(Date()), mode: .time)
//        .datePickerSelectionIndicatorFill(.mint)
//        .toolbar {
//          ToolbarItem(placement: .cancellationAction) {
//            Button("Cancel", role: .cancel, action: {})
//          }
//        }
//    }
//    .previewDevice(PreviewDevice(rawValue: "Apple Watch Series 6 - 44mm"))
//    .previewDisplayName("Mode: Time")
//
//    NavigationView {
//      DateInputView(selection: .constant(Date()), mode: .date)
//        .toolbar {
//          ToolbarItem(placement: .cancellationAction) {
//            Button("Cancel", role: .cancel, action: {})
//          }
//        }
//    }
//    .previewDevice(PreviewDevice(rawValue: "Apple Watch Series 6 - 44mm"))
//    .previewDisplayName("Mode: Date (Series 6 – 44mm)")
//    .environment(\.locale, Locale(identifier: "da-DK"))
//
//    NavigationView {
//      DateInputView(selection: .constant(Date()), mode: .date)
//        .toolbar {
//          ToolbarItem(placement: .cancellationAction) {
//            Button("Cancel", role: .cancel, action: {})
//          }
//        }
//    }
//    .previewDevice(PreviewDevice(rawValue: "Apple Watch Series 7 - 45mm"))
//    .previewDisplayName("Mode: Date (Series 7 – 45mm)")
//    .environment(\.locale, Locale(identifier: "da-DK"))
//
//    NavigationView {
//      DateInputView(selection: .constant(Date()), mode: .dateAndTime)
//        .toolbar {
//          ToolbarItem(placement: .cancellationAction) {
//            Button("Cancel", role: .cancel, action: {})
//          }
//        }
//    }
//    .previewDevice(PreviewDevice(rawValue: "Apple Watch Series 6 - 44mm"))
//    .previewDisplayName("Mode: Date & Time (Step 1)")
//
//    NavigationView {
//      NavigationLink(isActive: .constant(true)) {
//        TimeInputView(selection: .constant(Date()), mode: .dateAndTime)
//          .timeInputViewTwentyFourHour()
//          .tint(.pink)
//      } label: {
//        EmptyView()
//      }
//      .opacity(0)
//    }
//    .previewDevice(PreviewDevice(rawValue: "Apple Watch Series 6 - 44mm"))
//    .previewDisplayName("Mode: Date & Time (Step 2)")
  }
}
