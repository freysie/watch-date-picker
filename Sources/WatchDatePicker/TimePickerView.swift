import SwiftUI
import WatchKit

fileprivate let now = Date()
fileprivate let calendar = Calendar.current

public struct TimePickerView: View {
  @State public var date: Date = now
  public var mode: DatePicker.Mode = .time
  public var twentyFourHour: Bool = false
  public var selectionIndicatorRadius: CGFloat = 4.5
  public var selectionIndicatorColor: Color = .orange
  public var focusColor: Color?
  public var amPMHighlightColor: Color?
  public var markSize: CGSize?
  public var markFill: AnyShapeStyle?
  public var emphasizedMarkSize: CGSize?
  public var emphasizedMarkFill: AnyShapeStyle?
  public var onCompletion: ((Date) -> Void)?
  @Environment(\.dismiss) private var dismiss
  private enum HourPeriod: Int { case am = 0, pm = 12; var offset: Int { rawValue } }
  private enum Component { case hour, minute }
  @State private var hourPeriod = HourPeriod.am
  @State private var focusedComponent = Component.hour
  @State private var hour = 0
  @State private var minute = 0
  private var hourBinding: Binding<Double> { Binding { Double(hour) } set: { hour = Int($0) } }
  private var minuteBinding: Binding<Double> { Binding { Double(minute) } set: { minute = Int($0) } }
  private var hourMultiple: Int { twentyFourHour ? 24 : 12 }
  private var normalizedHour: Int { (hour < 0 ? hourMultiple - (abs(hour) % hourMultiple) : hour) % hourMultiple }
  private var normalizedMinute: Int { (minute < 0 ? 60 - (abs(minute) % 60) : minute) % 60 }
  
  private var formattedHour: String {
    String(twentyFourHour ? normalizedHour : normalizedHour == 0 ? hourMultiple : normalizedHour)
  }
  
  private var formattedMinute: String {
    String(format: "%02d", normalizedMinute)
  }
  
  public init(
    date: Date? = nil,
    mode: DatePicker.Mode = .time,
    twentyFourHour: Bool? = nil,
    selectionIndicatorRadius: Double = 4.5,
    selectionIndicatorColor: Color? = nil,
    focusColor: Color? = nil,
    amPMHighlightColor: Color? = nil,
    markSize: CGSize? = nil,
    markFill: AnyShapeStyle? = nil,
    emphasizedMarkSize: CGSize? = nil,
    emphasizedMarkFill: AnyShapeStyle? = nil,
    onCompletion: ((Date) -> Void)? = nil
  ) {
    self.date = date ?? now
    self.mode = mode
    if let value = twentyFourHour { self.twentyFourHour = value }
    self.selectionIndicatorRadius = selectionIndicatorRadius
    if let value = selectionIndicatorColor { self.selectionIndicatorColor = value }
    self.focusColor = focusColor
    self.amPMHighlightColor = amPMHighlightColor
    self.markSize = markSize
    self.markFill = markFill
    self.emphasizedMarkSize = emphasizedMarkSize
    self.emphasizedMarkFill = emphasizedMarkFill
    self.onCompletion = onCompletion
    hour = calendar.component(.hour, from: self.date)
    minute = calendar.component(.minute, from: self.date)
  }
  
  private var selection: Date {
    calendar.date(
      bySettingHour: normalizedHour + 1 + (twentyFourHour ? 0 : hourPeriod.offset),
      minute: normalizedMinute,
      second: 0,
      of: date
    )!
  }
  
  private func _onCompletion() {
    if mode == .time { dismiss() }
    onCompletion?(selection)
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
      if twentyFourHour {
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
    if twentyFourHour && component == .hour {
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
      .rotation(.degrees(Double(index) * 360 / multiple), anchor: UnitPoint.init(x: 0, y: 0))
      .fill(
        isEmphasized
        ? emphasizedMarkFill ?? AnyShapeStyle(HierarchicalShapeStyle.primary)
        : markFill ?? AnyShapeStyle(HierarchicalShapeStyle.tertiary)
      )
      .position(x: geometry.size.width, y: geometry.size.height)
  }
  
  private func selectionIndicator(for value: Int, multiple: Int, with geometry: GeometryProxy) -> some View {
    let effectiveEmphasizedMarkSize = emphasizedMarkSize ?? CGSize(width: 1.5, height: 3)
    let effectiveMarkSize = markSize ?? CGSize(width: 1, height: 7)
    
    return Circle()
      .size(width: selectionIndicatorRadius * 2, height: selectionIndicatorRadius * 2)
      .offset(x: -selectionIndicatorRadius, y: -selectionIndicatorRadius)
      .offset(y: geometry.size.height / 3)
      .offset(y: max(effectiveEmphasizedMarkSize.height, effectiveMarkSize.height))
      .rotation(.degrees(Double(value) * 360 / Double(multiple)), anchor: UnitPoint.init(x: 0, y: 0))
      .fill(selectionIndicatorColor)
      .animation(.spring(), value: value)
      .position(x: geometry.size.width, y: geometry.size.height)
  }
  
  private var pickerButtons: some View {
    VStack {
      Spacer()
      
      if twentyFourHour {
        Button("24 hour", action: {})
          .buttonStyle(.timePickerAMPM(isHighlighted: false))
          .textCase(.uppercase)
          .disabled(true)
      } else {
        Button(calendar.amSymbol, action: { hourPeriod = .am })
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
      
      Button(calendar.pmSymbol, action: { hourPeriod = .pm })
        .buttonStyle(.timePickerAMPM(isHighlighted: hourPeriod == .pm, highlightColor: amPMHighlightColor))
        .disabled(twentyFourHour)
        .opacity(!twentyFourHour ? 1 : 0)
      
      Spacer()
    }
    .offset(y: 10)
  }
}

struct TimePickerView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      TimePickerView()
        .previewDisplayName("Default")
      
      TimePickerView(twentyFourHour: true)
        .environment(\.locale, Locale(identifier: "sv"))
        .previewDisplayName("24-Hour Mode — Swedish")
    }
    .accentColor(.orange)
  }
}
