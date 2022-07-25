import SwiftUI

// TODO: use locale-specific time separators (like “.” instead of “:”)
// TODO: selection indicator with default size has like 2 px cut off by status bar when in 12 o’clock position
// TODO: figure out difference between `calendar` and `locale.calendar` (gregorian (current) and gregorian (fixed))

/// A control for the inputting of time values.
///
/// The `TimePickerView` displays a clockface interface that allows the user to select hour and minute. The view binds to a `Date` instance.
///
/// ![](TimePickerView.png)
/// ![](TimePickerView~custom.png)
@available(watchOS 8, *)
@available(macOS, unavailable)
@available(iOS, unavailable)
@available(tvOS, unavailable)
public struct TimePickerView: View {
  @Binding var selection: Date
  var mode: DatePicker.Mode = .time
  var onCompletion: ((Date) -> Void)?

  // @Environment(\.datePickerSelectionIndicator) var selectionIndicator
  // @Environment(\.datePickerMark) var mark
  // @Environment(\.datePickerHeavyMark) var heavyMark

  @Environment(\.datePickerTwentyFourHour) private var twentyFourHour
  @Environment(\.datePickerTwentyFourHourIndicator) private var twentyFourHourIndicator
  @Environment(\.datePickerAMPMHighlightTint) private var amPMHighlightTint
  @Environment(\.datePickerFocusTint) private var focusTint
  @Environment(\.datePickerMarkSize) private var markSize
  @Environment(\.datePickerMarkFill) private var markFill
  @Environment(\.datePickerHeavyMarkSize) private var heavyMarkSize
  @Environment(\.datePickerHeavyMarkFill) private var heavyMarkFill
  // @Environment(\.datePickerSelectionIndicatorShape) private var selectionIndicatorShape
  @Environment(\.datePickerSelectionIndicatorRadius) private var selectionIndicatorRadius
  @Environment(\.datePickerSelectionIndicatorFill) private var selectionIndicatorFill

  @Environment(\.locale) private var locale
  @Environment(\.calendar) private var calendar
  @Environment(\.dismiss) private var dismiss
  private enum HourPeriod: Int { case am = 0, pm = 12; var offset: Int { rawValue } }
  private enum Component { case hour, minute }
  @State private var hourPeriod = HourPeriod.am
  @State private var focusedComponent = Component.hour
  @State private var hour = 0
  @State private var minute = 0
  private var hourBinding: Binding<Double> { Binding { Double(hour) } set: { hour = Int($0) } }
  private var minuteBinding: Binding<Double> { Binding { Double(minute) } set: { minute = Int($0) } }
  private var hourMultiple: Int { twentyFourHour == true ? 24 : 12 }
  private var minuteMultiple: Int { 60 }
  private var normalizedHour: Int { (hour < 0 ? hourMultiple - (abs(hour) % hourMultiple) : hour) % hourMultiple }
  private var normalizedMinute: Int { (minute < 0 ? minuteMultiple - (abs(minute) % minuteMultiple) : minute) % minuteMultiple }
  
  private var formattedHour: String {
    String(twentyFourHour == true ? normalizedHour : normalizedHour == 0 ? hourMultiple : normalizedHour)
  }
  
  private var formattedMinute: String {
    String(format: "%02d", normalizedMinute)
  }
  
  private var newSelection: Date {
    locale.calendar.date(
      bySettingHour: normalizedHour + (twentyFourHour == true ? 0 : hourPeriod.offset),
      minute: normalizedMinute,
      second: 0,
      of: selection
    )!
  }
  
  /// Creates a time picker view instance with the specified properties.
  /// - Parameters:
  ///   - selection:The date value being displayed and selected.
  ///   - mode: The style that the date picker is using for its layout.
  ///   - selectionIndicatorRadius: The radius of the time selection indicators.
  ///   Default is 2.25.
  ///   When `mode` is `.date`, this value is ignored.
  ///   - selectionIndicatorColor: The color for the time selection indicators.
  ///   Default is accent color.
  ///   When `mode` is `.date`, this value is ignored.
  ///   - focusColor: The color for the focus outline of time fields.
  ///   Default is green.
  ///   - markSize: …
  ///   - markFill: …
  ///   - emphasizedMarkSize: …
  ///   - emphasizedMarkFill: …
  ///   - onCompletion: A callback that will be invoked when the operation has succeeded.
  public init(selection: Binding<Date>, mode: DatePicker.Mode = .time, onCompletion: ((Date) -> Void)? = nil) {
    _selection = selection
    self.mode = mode
    self.onCompletion = onCompletion
    _hour = State(initialValue: locale.calendar.component(.hour, from: self.selection))
    _minute = State(initialValue: locale.calendar.component(.minute, from: self.selection))
    
    // print((calendar, locale.calendar, calendar == locale.calendar))
    // FIXME: rework this now that we’re using environment:
//    if !(twentyFourHour == true) {
      _hourPeriod = State(initialValue: hour <= 12 ? .am : .pm)
//      // if hourPeriod == .pm { hour %= 12 }
//    }
  }
  
  /// The content and behavior of the view.
  public var body: some View {
    ZStack(alignment: .bottom) {
      clockFace
      pickerButtons
    }
    // .drawingGroup(opaque: true)
    // .edgesIgnoringSafeArea(.all)
//    .toolbar {
//      ToolbarItem(placement: .confirmationAction) {
//        Button("Done", action: _onCompletion)
//      }
//    }
    // TODO: AM/PM wrapping
    //    .onChange(of: $value) { newValue in
    //      if newValue.
    //    }
  }
  
  private func _onCompletion() {
    if mode == .time { dismiss() }
    onCompletion?(newSelection)
  }
  
  private var clockFace: some View {
    GeometryReader { geometry in
      labels(with: geometry)
      
      switch focusedComponent {
      case .hour:
        marks(for: .hour, with: geometry)
        selectionIndicator(for: hour, multiple: hourMultiple, with: geometry)
      case .minute:
        marks(for: .minute, with: geometry)
        selectionIndicator(for: minute, multiple: 60, with: geometry)
      }
    }
    .padding(-13)
    .offset(y: 11.5)
  }
  
  private func labels(with geometry: GeometryProxy) -> some View {
    switch focusedComponent {
    case .hour:
      if twentyFourHour == true {
        return ForEach(0..<12) { index in
          label(String(format: "%02d", Int(index * 2)), at: index, with: geometry)
        }
      } else {
        return ForEach(0..<12) { index in
          label(String(Int(index == 0 ? 12 : index)), at: index, with: geometry)
        }
      }
    case .minute:
      return ForEach(0..<12) { index in
        label(String(format: "%02d", Int(index * 5)), at: index, with: geometry)
      }
    }
  }
  
  private static let offsetLabels = [1, 2, 3, 4, 5, 7, 8, 9].map(String.init)
  
  private func label(_ string: String, at index: Int, with geometry: GeometryProxy) -> some View {
    ZStack {
      Text(string)
        .rotationEffect(.degrees(-Double(index) * 360 / 12), anchor: .center)
        .padding(.bottom, geometry.size.height * (Self.offsetLabels.contains(string) ? 0.62 : 0.6))
    }
    .rotationEffect(.degrees(Double(index) * 360 / 12), anchor: .center)
    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
    .font(.system(size: 15))
  }
  
  private func marks(for component: Component, with geometry: GeometryProxy) -> some View {
    if twentyFourHour == true && component == .hour {
      return ForEach(0..<48) { index in
        mark(at: index, multiple: 48, heavy: index % 4 == 0, with: geometry)
      }
    } else {
      return ForEach(0..<60) { index in
        mark(at: index, multiple: 60, heavy: index % 5 == 0, with: geometry)
      }
    }
  }
  
  private func mark(at index: Int, multiple: Double, heavy: Bool = false, with geometry: GeometryProxy) -> some View {
    let effectiveEmphasizedMarkSize = heavyMarkSize ?? CGSize(width: 1.5, height: 2.5)
    let effectiveMarkSize = markSize ?? CGSize(width: 1, height: 6.5)
    let size = heavy ? effectiveEmphasizedMarkSize : effectiveMarkSize
    
    return Rectangle()
      .size(size)
      .offset(x: -size.width / 2.0, y: 0)
      .offset(y: geometry.size.height / 3)
      // .offset(y: (heavy ? effectiveMarkSize.height - effectiveEmphasizedMarkSize.height : 0) + 0.5)
      .offset(y: heavy ? effectiveMarkSize.height - effectiveEmphasizedMarkSize.height : 0)
      .rotation(.degrees(Double(index) * 360 / multiple), anchor: .topLeading)
      .fill(heavy ? heavyMarkFill ?? AnyShapeStyle(.primary) : markFill ?? AnyShapeStyle(.tertiary))
      .position(x: geometry.size.width, y: geometry.size.height)
  }
  
  private func selectionIndicator(for value: Int, multiple: Int, with geometry: GeometryProxy) -> some View {
    let effectiveRadius = selectionIndicatorRadius ?? 2.25
    let effectiveEmphasizedMarkSize = heavyMarkSize ?? CGSize(width: 1.5, height: 3)
    let effectiveMarkSize = markSize ?? CGSize(width: 1, height: 7)
    let rotationDegrees = Double(value) * 360 / Double(multiple)
    // print("value = \(value); multiple = \(multiple); degrees = \(rotationDegrees)")
    
    return Circle()
      .size(width: effectiveRadius * 2, height: effectiveRadius * 2)
      .offset(x: -effectiveRadius, y: -effectiveRadius)
      .offset(y: geometry.size.height / 3)
      .offset(y: max(effectiveEmphasizedMarkSize.height, effectiveMarkSize.height) - 1)
      .rotation(.degrees(180 + rotationDegrees), anchor: .topLeading)
      .fill(selectionIndicatorFill ?? AnyShapeStyle(.orange))
      .animation(.spring(), value: value)
      .position(x: geometry.size.width, y: geometry.size.height)
    
//    return self.selectionIndicator!
//      .offset(y: geometry.size.height / 3)
//      .rotationEffect(.degrees(180 + rotationDegrees), anchor: .topLeading)
//      .animation(.spring(), value: value)
//      .position(x: geometry.size.width, y: geometry.size.height)
  }
  
  private var pickerButtons: some View {
    VStack {
      Spacer()
      
      if twentyFourHour == true {
        Button("24hr", action: {})
          .buttonStyle(.timePickerAMPM(isHighlighted: false))
          .textCase(.uppercase)
          .disabled(true)
          .opacity(twentyFourHourIndicator != .hidden ? 1 : 0)
          .offset(y: 4)
      } else {
        Button(action: { hourPeriod = .am }) {
          Text(verbatim: locale.calendar.amSymbol)
            .tracking(-1)
        }
          .buttonStyle(.timePickerAMPM(isHighlighted: hourPeriod == .am, highlightColor: amPMHighlightTint))
          .offset(y: -1)
      }
      
      HStack {
        Button(formattedHour, action: { focusedComponent = .hour })
          .buttonStyle(.timePickerComponent(isFocused: focusedComponent == .hour, focusColor: focusTint))
          .focusable()
          .digitalCrownRotation(
            hourBinding,
            from: -Double.infinity,
            through: Double.infinity,
            by: nil,
            sensitivity: .low,
            isContinuous: true,
            isHapticFeedbackEnabled: true
          )
        //          .onChange(of: hourBinding) { _ in
        //            WKInterfaceDevice.current().play(.notification)
        //          }
        
        Text(":")
          .padding(.bottom, 7)
          .padding(.horizontal, -1)
        
        Button(formattedMinute, action: { focusedComponent = .minute })
          .buttonStyle(.timePickerComponent(isFocused: focusedComponent == .minute, focusColor: focusTint))
          .focusable()
          .digitalCrownRotation(
            minuteBinding,
            from: -Double.infinity,
            through: Double.infinity,
            by: nil,
            sensitivity: .medium,
            isContinuous: true,
            isHapticFeedbackEnabled: true
          )
        //          .onChange(of: minuteBinding.projectedValue) { _ in
        //            WKInterfaceDevice.current().play(.click)
        //          }
      }
      .font(.system(size: 32))
      
      Button(action: { hourPeriod = .pm }) {
        Text(verbatim: locale.calendar.pmSymbol)
          .tracking(-0.6)
      }
        .buttonStyle(.timePickerAMPM(isHighlighted: hourPeriod == .pm, highlightColor: amPMHighlightTint))
        .disabled(twentyFourHour == true)
        .opacity(twentyFourHour == true ? 0 : 1)
        .offset(y: 3)
      
      Spacer()
    }
    .offset(y: 10)
  }
}

@available(macOS, unavailable)
@available(iOS, unavailable)
@available(tvOS, unavailable)
struct TimePickerView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      TimePickerView(selection: .constant(Date()))
        .previewDisplayName("Default")
      
      TimePickerView(selection: .constant(Date()))
        .datePickerTwentyFourHour()
        .environment(\.locale, Locale(identifier: "sv"))
        .previewDisplayName("24-Hour Mode — Swedish")
    }
    .accentColor(.orange)
  }
}
