import SwiftUI

// TODO: maybe use locale-specific (region-specific?) time separators (like “.” instead of “:”)
// TODO: figure out difference between `calendar` and `locale.calendar` (gregorian (current) and gregorian (fixed))
// TODO: cache the clock face to an image for better performance?

/// A control for the inputting of time values.
///
/// The `TimeInputView` displays a clockface interface that allows the user to select hour and minute. The view binds to a `Date` instance.
///
/// ![](TimeInputView.png)
/// ![](TimeInputView~custom.png)
@available(watchOS 8, *)
@available(macOS, unavailable)
@available(iOS, unavailable)
@available(tvOS, unavailable)
public struct TimeInputView: View {
  @Binding var selection: Date
  let initialSelection: Date

  @Environment(\.locale) private var locale
  @Environment(\.timeInputViewMonospacedDigit) private var monospacedDigit
  @Environment(\.timeInputViewTwentyFourHour) private var _twentyFourHour
  @Environment(\.timeInputViewTwentyFourHourIndicator) private var twentyFourHourIndicator
  @Environment(\.timeInputViewSelectionTint) private var selectionTint

  private var twentyFourHour: Bool { _twentyFourHour ?? locale.uses24HourTime == true }

  private enum HourPeriod: Int {
    case am = 0, pm = 12

    var offset: Int { rawValue }

    var sign: Int {
      switch self {
      case .am: return -12
      case .pm: return +12
      }
    }
  }
  
  private enum Component {
    case hour, minute
  }
  
  private var hourPeriod: HourPeriod {
    get {
      abs(hour < 0 ? hour - 12 : hour) % 24 < 12 ? .am : .pm
    }
    // mutating set {
    //   switch newValue {
    //   case .am: hour -= 12
    //   case .pm: hour += 12
    //   }
    // }
  }
  
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

  // TODO: rethink this
  private var newSelection: Date {
    guard let result = locale.calendar.date(
      bySettingHour: normalizedHour + (twentyFourHour == true ? 0 : hourPeriod.offset),
      minute: normalizedMinute,
      second: 0,
      of: initialSelection
    ) else {
      NSLog("[WatchDatePicker] invalid new selection (\(initialSelection), \(normalizedHour), \(normalizedMinute), \(hourPeriod))")
      return initialSelection
    }

    return result
  }

  /// Creates a time input view instance with the specified properties.
  /// - Parameters:
  ///   - selection:The date value being displayed and selected.
  public init(selection: Binding<Date>) {
    _selection = selection
    initialSelection = selection.wrappedValue
    _hour = State(initialValue: locale.calendar.component(.hour, from: self.selection))
    _minute = State(initialValue: locale.calendar.component(.minute, from: self.selection))

    // print((calendar, locale.calendar, calendar == locale.calendar))
    // FIXME: rework this now that we’re using environment:
//    if !(twentyFourHour == true) {
      // _hourPeriod = State(initialValue: hour <= 12 ? .am : .pm)
//      // if hourPeriod == .pm { hour %= 12 }
//    }
  }

  /// The content and behavior of the view.
  public var body: some View {
    ZStack {
      clockFace
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(clockFacePadding)
        .drawingGroup(opaque: true)
        //.border(.mint)
        //.border(.green)
        // .clipped()
        // .border(.red)

      pickerButtons
        // .border(.brown)
    }
    .onChange(of: newSelection) {
      selection = $0
    }
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
  }
  
  private var clockFacePadding: Double {
    switch WKInterfaceDevice.current().screenBounds.width {
    case 162: return -15 // 40 mm
    case 176: return -21 // 41 mm
    case 198: return -23 // 45 mm
    default: return -13
    }
  }
  
  // private var clockFaceOffsetY: Double {
  //   switch WKInterfaceDevice.current().screenBounds.width {
  //   case 162: return 9.5 // 40 mm
  //   case 176: return 11 // 41 mm
  //   case 198: return 8.5 // 45 mm
  //   default: return 11.5
  //   }
  // }

  // private var clockFacePadding2: Double {
  //   [
  //     162: -15.0,
  //     198: -25.0
  //   ][
  //     WKInterfaceDevice.current().screenBounds.width
  //   ]!
  // }

  private var componentFontSize: Double {
    switch WKInterfaceDevice.current().screenBounds.width {
    case 162: return 28 // 40 mm
    case 176: return 34.5 // 41 mm
    case 198: return 39 // 45 mm
    default: return 32
    }
  }

  private var selectionIndicatorRadius: Double {
    switch WKInterfaceDevice.current().screenBounds.width {
    case 198: return 2.75 // 45 mm
    default: return 2.25
    }
  }

  private var heavyMarkSize: CGSize {
    switch WKInterfaceDevice.current().screenBounds.width {
    case 198: return CGSize(width: 2, height: 2.5) // 45 mm
    default: return CGSize(width: 1.5, height: 2.5)
    }
  }

  private var markSize: CGSize {
    switch WKInterfaceDevice.current().screenBounds.width {
    case 198: return CGSize(width: 1.75, height: 7.5) // 45 mm
    default: return CGSize(width: 1.25, height: 6.5)
    }
  }

  private func labels(with geometry: GeometryProxy) -> some View {
    // print((geometry.size, geometry.safeAreaInsets))
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
    let size = heavy ? heavyMarkSize : markSize

    return Rectangle()
      .size(size)
      .offset(x: -size.width / 2.0, y: 0)
      .offset(y: geometry.size.height / 3)
      // .offset(y: (heavy ? markSize.height - heavyMarkSize.height : 0) + 0.5)
      .offset(y: heavy ? markSize.height - heavyMarkSize.height : 0)
      .rotation(.degrees(Double(index) * 360 / multiple), anchor: .topLeading)
      .fill(heavy ? AnyShapeStyle(.primary) : AnyShapeStyle(.tertiary))
      .position(x: geometry.size.width, y: geometry.size.height)
  }

  private func selectionIndicator(for value: Int, multiple: Int, with geometry: GeometryProxy) -> some View {
    let rotationDegrees = Double(value) * 360 / Double(multiple)
    // print("value = \(value); multiple = \(multiple); degrees = \(rotationDegrees)")

    return Circle()
      .size(width: selectionIndicatorRadius * 2, height: selectionIndicatorRadius * 2)
      .offset(x: -selectionIndicatorRadius, y: -selectionIndicatorRadius)
      .offset(y: geometry.size.height / 3)
      .offset(y: max(heavyMarkSize.height, markSize.height) - 1)
      .rotation(.degrees(180 + rotationDegrees), anchor: .topLeading)
      .fill(selectionTint.map { AnyShapeStyle($0) } ?? AnyShapeStyle(.tint))
      .animation(.spring(), value: value)
      .position(x: geometry.size.width, y: geometry.size.height)

//    return self.selectionIndicator!
//      .offset(y: geometry.size.height / 3)
//      .rotationEffect(.degrees(180 + rotationDegrees), anchor: .topLeading)
//      .animation(.spring(), value: value)
//      .position(x: geometry.size.width, y: geometry.size.height)
  }
  
  private func setHourPeriod(_ period: HourPeriod) {
    guard hourPeriod != period else { return }
    var t = Transaction()
    t.disablesAnimations = true
    withTransaction(t) { hour += period.sign }
  }

  private var pickerButtons: some View {
    VStack {
      // Spacer()

      if twentyFourHour == true {
        Button(action: {}) {
          Text("24\(Text("HR").font(.system(size: 15)))")
          // Text("24hr")
        }
          .buttonStyle(.timePeriod(isHighlighted: false))
          .tint(.gray)
          .textCase(.uppercase)
          .disabled(true)
          .opacity(twentyFourHourIndicator != .hidden ? 1 : 0)
          .offset(y: 4)
      } else {
        Button(action: { setHourPeriod(.am) }) {
          Text(verbatim: locale.calendar.amSymbol)
            .tracking(locale.calendar.amSymbol == "AM" ? -0.5 : 0)
        }
          .buttonStyle(.timePeriod(isHighlighted: hourPeriod == .am))
          .offset(y: -1)
      }

      HStack {
        Button(formattedHour, action: { focusedComponent = .hour })
          .buttonStyle(.timeComponent(isFocused: focusedComponent == .hour))
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

        Text(":")
          .padding(.bottom, 7)
          .padding(.horizontal, -1)

        Button(formattedMinute, action: { focusedComponent = .minute })
          .buttonStyle(.timeComponent(isFocused: focusedComponent == .minute))
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
      }
      .font(
        monospacedDigit == true
        ? .system(size: componentFontSize).monospacedDigit()
        : .system(size: componentFontSize)
      )

      Button(action: { setHourPeriod(.pm) }) {
        Text(verbatim: locale.calendar.pmSymbol)
          .tracking(locale.calendar.pmSymbol == "PM" ? -0.6 : 0)
      }
        .buttonStyle(.timePeriod(isHighlighted: hourPeriod == .pm))
        .disabled(twentyFourHour == true)
        .opacity(twentyFourHour == true ? 0 : 1)
        .offset(y: 3)

      // Spacer()
    }
    // .offset(y: 10)
  }
}

@available(macOS, unavailable)
@available(iOS, unavailable)
@available(tvOS, unavailable)
struct TimeInputView_Previews: PreviewProvider {
  static var previews: some View {
    TimeInputView(selection: .constant(Date()))
      .previewDisplayName("Default")
    
    TimeInputView(selection: .constant(Date()))
      .timeInputViewTwentyFourHour()
      .previewDisplayName("24hr")
    
    TimeInputView(selection: .constant(Date()))
      .environment(\.locale, Locale(identifier: "sv"))
      .previewDisplayName("Swedish")
    
    TimeInputView(selection: .constant(Date()))
      .tint(.pink)
      .previewDisplayName("Pink")
      
//    TimeInputView(selection: .constant(Date()))
//      .previewDevice("Apple Watch Series 7 - 45mm")
//
//    TimeInputView(selection: .constant(Date()))
//      .previewDevice("Apple Watch Series 6 - 44mm")
//
//    TimeInputView(selection: .constant(Date()))
//      .previewDevice("Apple Watch Series 7 - 41mm")
//
//    TimeInputView(selection: .constant(Date()))
//      .previewDevice("Apple Watch Series 6 - 40mm")
  }
}
