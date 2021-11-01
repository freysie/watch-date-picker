import SwiftUI
import WatchKit

// TODO: selection indicator with default size is cut off by status bar when in 12 o’clock position

public struct TimePickerView: View {
  @Binding public var selection: Date
  public var mode: DatePicker.Mode = .time
  public var twentyFourHour: Bool?
  public var showsTwentyFourHourIndicator: Bool?
  public var selectionIndicatorRadius: CGFloat?
  public var selectionIndicatorColor: Color?
  public var focusColor: Color?
  public var amPMHighlightColor: Color?
  public var markSize: CGSize?
  public var markFill: AnyShapeStyle?
  public var emphasizedMarkSize: CGSize?
  public var emphasizedMarkFill: AnyShapeStyle?
  public var onCompletion: ((Date) -> Void)?

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
  
  public init(
    selection: Binding<Date>,
    mode: DatePicker.Mode = .time,
    twentyFourHour: Bool? = nil,
    showsTwentyFourHourIndicator: Bool? = nil,
    selectionIndicatorRadius: CGFloat? = nil,
    selectionIndicatorColor: Color? = nil,
    focusColor: Color? = nil,
    amPMHighlightColor: Color? = nil,
    markSize: CGSize? = nil,
    markFill: AnyShapeStyle? = nil,
    emphasizedMarkSize: CGSize? = nil,
    emphasizedMarkFill: AnyShapeStyle? = nil,
    onCompletion: ((Date) -> Void)? = nil
  ) {
    _selection = selection
    self.mode = mode
    self.twentyFourHour = twentyFourHour
    self.showsTwentyFourHourIndicator = showsTwentyFourHourIndicator
    self.selectionIndicatorRadius = selectionIndicatorRadius
    self.selectionIndicatorColor = selectionIndicatorColor
    self.focusColor = focusColor
    self.amPMHighlightColor = amPMHighlightColor
    self.markSize = markSize
    self.markFill = markFill
    self.emphasizedMarkSize = emphasizedMarkSize
    self.emphasizedMarkFill = emphasizedMarkFill
    self.onCompletion = onCompletion
    _hour = State(initialValue: locale.calendar.component(.hour, from: self.selection))
    _minute = State(initialValue: locale.calendar.component(.minute, from: self.selection))
    if !(twentyFourHour == true) {
      _hourPeriod = State(initialValue: hour <= 12 ? .am : .pm)
      // if hourPeriod == .pm { hour %= 12 }
    }
  }
  
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
        mark(at: index, multiple: 48, isEmphasized: index % 4 == 0, with: geometry)
      }
    } else {
      return ForEach(0..<60) { index in
        mark(at: index, multiple: 60, isEmphasized: index % 5 == 0, with: geometry)
      }
    }
  }
  
  private func mark(
    at index: Int,
    multiple: Double,
    isEmphasized: Bool = false,
    with geometry: GeometryProxy
  ) -> some View {
    let effectiveEmphasizedMarkSize = emphasizedMarkSize ?? CGSize(width: 1.5, height: 3)
    let effectiveMarkSize = markSize ?? CGSize(width: 1, height: 7)
    let size = isEmphasized ? effectiveEmphasizedMarkSize : effectiveMarkSize
    
    return Rectangle()
      .size(size)
      .offset(x: -size.width / 2, y: 0)
      .offset(y: geometry.size.height / 3)
    // FIXME: opposite should work too
      .offset(y: isEmphasized ? effectiveMarkSize.height - effectiveEmphasizedMarkSize.height : 0)
      .rotation(.degrees(Double(index) * 360 / multiple), anchor: .topLeading)
      .fill(
        isEmphasized
        ? emphasizedMarkFill ?? AnyShapeStyle(HierarchicalShapeStyle.primary)
        : markFill ?? AnyShapeStyle(HierarchicalShapeStyle.tertiary)
      )
      .position(x: geometry.size.width, y: geometry.size.height)
  }
  
  private func selectionIndicator(for value: Int, multiple: Int, with geometry: GeometryProxy) -> some View {
    let effectiveRadius = selectionIndicatorRadius ?? 2.25
    let effectiveEmphasizedMarkSize = emphasizedMarkSize ?? CGSize(width: 1.5, height: 3)
    let effectiveMarkSize = markSize ?? CGSize(width: 1, height: 7)
    let rotationDegrees = Double(value) * 360 / Double(multiple)
    // print("value = \(value); multiple = \(multiple); degrees = \(rotationDegrees)")

    return Circle()
      .size(width: effectiveRadius * 2, height: effectiveRadius * 2)
      .offset(x: -effectiveRadius, y: -effectiveRadius)
      .offset(y: geometry.size.height / 3)
      .offset(y: max(effectiveEmphasizedMarkSize.height, effectiveMarkSize.height))
      .rotation(.degrees(180 + rotationDegrees), anchor: .topLeading)
      .fill(selectionIndicatorColor ?? .orange)
      .animation(.spring(), value: value)
      .position(x: geometry.size.width, y: geometry.size.height)
      .border(.mint)
  }
  
  private var pickerButtons: some View {
    VStack {
      Spacer()
      
      if twentyFourHour == true {
        Button("24 hour", action: {})
          .buttonStyle(.timePickerAMPM(isHighlighted: false))
          .textCase(.uppercase)
          .disabled(true)
          .opacity(showsTwentyFourHourIndicator != false ? 1 : 0)
      } else {
        Button(locale.calendar.amSymbol, action: { hourPeriod = .am })
          .buttonStyle(.timePickerAMPM(isHighlighted: hourPeriod == .am, highlightColor: amPMHighlightColor))
      }
      
      HStack {
        Button(formattedHour, action: { focusedComponent = .hour })
          .buttonStyle(.timePickerComponent(isFocused: focusedComponent == .hour, focusColor: focusColor))
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
          .buttonStyle(.timePickerComponent(isFocused: focusedComponent == .minute, focusColor: focusColor))
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
        .buttonStyle(.timePickerAMPM(isHighlighted: hourPeriod == .pm, highlightColor: amPMHighlightColor))
        .disabled(twentyFourHour == true)
        .opacity(twentyFourHour == true ? 0 : 1)
      
      Spacer()
    }
    .offset(y: 10)
  }
}

struct TimePickerView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      TimePickerView(selection: .constant(Date()))
        .previewDisplayName("Default")
      
      TimePickerView(selection: .constant(Date()), twentyFourHour: true)
        .environment(\.locale, Locale(identifier: "sv"))
        .previewDisplayName("24-Hour Mode — Swedish")
    }
    .accentColor(.orange)
  }
}
