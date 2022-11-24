#if os(watchOS)
import SwiftUI

// TODO: cache the clock face to an image for better performance?

/// A control for the inputting of time values.
///
/// The `TimeInputView` displays a clock face interface that allows the user to select hour and minute. The view binds to a `Date` instance.
///
/// ![](TimeInputView.png)
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
    get { abs(hour < 0 ? hour - 12 : hour) % 24 < 12 ? .am : .pm }
  }
  
  private func setHourPeriod(_ period: HourPeriod) {
    guard hourPeriod != period else { return }
    var t = Transaction()
    t.disablesAnimations = true
    withTransaction(t) { hour += period.sign }
  }
  
  @State private var focusedComponent = Component.hour
  @State private var hour = 0
  @State private var minute = 0
  private var hourBinding: Binding<Double> {
    Binding { Double(hour) }
    set: {
      hour = Int($0)
    }
  }
  
  private var minuteBinding: Binding<Double> {
    Binding { Double(minute) }
    set: {
      minute = Int($0)
    }
  }
  
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
  
  // MARK: Size Vars
  @State private var rootSize: CGSize = .zero
  @State private var clockFaceSize: CGSize = .zero

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
  }

  /// The content and behavior of the view.
  public var body: some View {
    ZStack {
      clockFace
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(clockFacePadding())
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
    .background(GeometryReader { proxy in
      Color.clear
        .onAppear {
          self.rootSize = proxy.size
          self.clockFaceSize = CGSize(
            width: proxy.size.width - proxy.safeAreaInsets.leading - proxy.safeAreaInsets.trailing,
            height: proxy.size.height - proxy.safeAreaInsets.top - proxy.safeAreaInsets.bottom
          )
        }
    })
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
  
  /// padding to use for the clock face
  ///
  /// always negative, offsets the clock face from the center
  private func clockFacePadding() -> CGFloat {
    guard rootSize == .zero, clockFaceSize == .zero else {
      return clockFaceSize.height - rootSize.height + 8.0
    }
    
    return -23.0
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
    .position(x: geometry.size.width * 0.5, y: geometry.size.height * 0.5)
    .font(.callout)
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
    let size: CGSize = heavy ? .heavyMarkSize : .markSize

    return Rectangle()
      .size(size)
      .offset(x: -size.width * 0.5, y: 0)
      .offset(y: geometry.size.height / 3)
      .offset(y: heavy ? CGSize.markSize.height - CGSize.heavyMarkSize.height : 0)
      .rotation(.degrees(Double(index) * 360 / multiple), anchor: .topLeading)
      .fill(heavy ? AnyShapeStyle(.primary) : AnyShapeStyle(.tertiary))
      .position(x: geometry.size.width, y: geometry.size.height)
  }

  private func selectionIndicator(for value: Int, multiple: Int, with geometry: GeometryProxy) -> some View {
    let rotationDegrees = Double(value) * 360 / Double(multiple)

    return Circle()
      .size(width: .selectionIndicatorRadius * 2, height: .selectionIndicatorRadius * 2)
      .offset(x: -.selectionIndicatorRadius, y: -.selectionIndicatorRadius)
      .offset(y: geometry.size.height / 3)
      .offset(y: max(CGSize.heavyMarkSize.height, CGSize.markSize.height) - 1)
      .rotation(.degrees(180 + rotationDegrees), anchor: .topLeading)
      .fill(selectionTint.map { AnyShapeStyle($0) } ?? AnyShapeStyle(.tint))
      .animation(.spring(), value: value)
      .position(x: geometry.size.width, y: geometry.size.height)
  }
  
  private var twentyFourHourIndicatorView: some View {
    Button(action: {}) {
      Text("24\(Text("HR").font(.callout))")
    }
    .buttonStyle(.timePeriod(isHighlighted: false))
    .tint(.gray)
    .textCase(.uppercase)
    .disabled(true)
    .opacity(twentyFourHourIndicator != .hidden ? 1 : 0)
    .offset(y: 4)
  }
  
  private var pickerButtons: some View {
    VStack {
      if twentyFourHour == true {
        twentyFourHourIndicatorView
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
            from: 0,
            through: 24,
            by: 1,
            sensitivity: .medium,
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
            from: 0,
            through: 60,
            by: 1,
            sensitivity: .medium,
            isContinuous: true,
            isHapticFeedbackEnabled: true
          )
      }
      .font(
        monospacedDigit == true
        ? .title2.monospacedDigit()
        : .title2
      )

      if twentyFourHour == true {
        twentyFourHourIndicatorView
          .opacity(0)
      } else {
        Button(action: { setHourPeriod(.pm) }) {
          Text(verbatim: locale.calendar.pmSymbol)
            .tracking(locale.calendar.pmSymbol == "PM" ? -0.6 : 0)
        }
        .buttonStyle(.timePeriod(isHighlighted: hourPeriod == .pm))
        .disabled(twentyFourHour == true)
        .opacity(twentyFourHour == true ? 0 : 1)
        .offset(y: 3)
      }
    }
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
#endif
