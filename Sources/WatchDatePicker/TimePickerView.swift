import SwiftUI

// TODO: use locale-specific time separators (like “.” instead of “:”)
// TODO: selection indicator with default size is cut off by status bar when in 12 o’clock position

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
  public init(
    selection: Binding<Date>,
    mode: DatePicker.Mode = .time,
//    selectionIndicatorRadius: CGFloat? = nil,
//    selectionIndicatorColor: Color? = nil,
//    markSize: CGSize? = nil,
//    markFill: AnyShapeStyle? = nil,
//    emphasizedMarkSize: CGSize? = nil,
//    emphasizedMarkFill: AnyShapeStyle? = nil,
    onCompletion: ((Date) -> Void)? = nil
  ) {
    _selection = selection
    self.mode = mode
//    self.selectionIndicatorRadius = selectionIndicatorRadius
//    self.selectionIndicatorColor = selectionIndicatorColor
//    self.markSize = markSize
//    self.markFill = markFill
//    self.emphasizedMarkSize = emphasizedMarkSize
//    self.emphasizedMarkFill = emphasizedMarkFill
    self.onCompletion = onCompletion
    _hour = State(initialValue: locale.calendar.component(.hour, from: self.selection))
    _minute = State(initialValue: locale.calendar.component(.minute, from: self.selection))
    
    // FIXME: rework this now that we’re using environment:
//    if !(twentyFourHour == true) {
//      _hourPeriod = State(initialValue: hour <= 12 ? .am : .pm)
//      // if hourPeriod == .pm { hour %= 12 }
//    }
  }
  
  /// The content and behavior of the view.
  public var body: some View {
    ZStack(alignment: .bottom) {
      clockFace
      pickerButtons
    }
    .drawingGroup(opaque: true)
    .edgesIgnoringSafeArea(.all)
    .toolbar {
      ToolbarItem(placement: .confirmationAction) {
        Button("Done", action: _onCompletion)
      }
    }
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
      
      if focusedComponent == .hour {
        marks(for: .hour, with: geometry)
        selectionIndicator(for: hour, multiple: hourMultiple, with: geometry)
      }
      
      if focusedComponent == .minute {
        marks(for: .minute, with: geometry)
        selectionIndicator(for: minute, multiple: 60, with: geometry)
      }
    }
    .padding(-10)
    .offset(y: 10)
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
  
  private func label(_ string: String, at index: Int, with geometry: GeometryProxy) -> some View {
    ZStack {
      Text(string)
        .rotationEffect(.degrees(-Double(index) * 360 / 12), anchor: .center)
        .padding(.bottom, geometry.size.height * 0.58)
    }
    .rotationEffect(.degrees(Double(index) * 360 / 12), anchor: .center)
    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
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
    let effectiveEmphasizedMarkSize = heavyMarkSize ?? CGSize(width: 1.5, height: 3)
    let effectiveMarkSize = markSize ?? CGSize(width: 1, height: 7)
    let size = heavy ? effectiveEmphasizedMarkSize : effectiveMarkSize
    
    return Rectangle()
      .size(size)
      .offset(x: -size.width / 2.0, y: 0)
      .offset(y: geometry.size.height / 3)
      // FIXME: opposite should work too
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
      .offset(y: max(effectiveEmphasizedMarkSize.height, effectiveMarkSize.height))
      .rotation(.degrees(180 + rotationDegrees), anchor: .topLeading)
      .fill(selectionIndicatorFill ?? AnyShapeStyle(.orange))
      .animation(.spring(), value: value)
      .position(x: geometry.size.width, y: geometry.size.height)
      .border(.mint)
    
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
        Button("24 hour", action: {})
          .buttonStyle(.timePickerAMPM(isHighlighted: false))
          .textCase(.uppercase)
          .disabled(true)
          .opacity(twentyFourHourIndicator != .hidden ? 1 : 0)
      } else {
        Button(locale.calendar.amSymbol, action: { hourPeriod = .am })
          .buttonStyle(.timePickerAMPM(isHighlighted: hourPeriod == .am, highlightColor: amPMHighlightTint))
      }
      
      HStack {
        Button(formattedHour, action: { focusedComponent = .hour })
          .buttonStyle(.timePickerComponent(isFocused: focusedComponent == .hour, focusColor: focusTint))
          .focusable()
          .digitalCrownRotation(
            hourBinding,
            //            from: 0.0,
            //            through: 12.0,
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
        
        //        Text(String(normalizedHour == 0 ? 12 : normalizedHour))
        //          .focusable()
        //          .digitalCrownRotation(
        //            $hour,
        //            from: 0.0,
        //            through: 12.0,
        //            by: nil,
        //            sensitivity: .low,
        //            isContinuous: true,
        //            isHapticFeedbackEnabled: true
        //          )
        
        Text(":")
          .padding(.bottom)
        
        Button(formattedMinute, action: { focusedComponent = .minute })
          .buttonStyle(.timePickerComponent(isFocused: focusedComponent == .minute, focusColor: focusTint))
          .focusable()
          .digitalCrownRotation(
            minuteBinding,
            //            from: 0.0,
            //            through: 60.0,
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
      .font(.title2)
      
      Button(locale.calendar.pmSymbol, action: { hourPeriod = .pm })
        .buttonStyle(.timePickerAMPM(isHighlighted: hourPeriod == .pm, highlightColor: amPMHighlightTint))
        .disabled(twentyFourHour == true)
        .opacity(twentyFourHour == true ? 0 : 1)
      
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
