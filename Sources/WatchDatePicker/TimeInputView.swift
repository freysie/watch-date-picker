import SwiftUI
import Combine

// TODO: find out what is causing the performance hiccup

// TODO: accessibility:
// 12 o’clock, PM. Adjustable. Slide up or down with one finger to adjust the value.
// 28 minutes. Adjustable. Slide up or down with one finger to adjust the value.
// Selected. PM. Button.
// Cancel. Button.
// Done. Button.

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

  private let initialSelection: Date

  @Environment(\.locale) private var locale
  @Environment(\.timeInputViewMonospacedDigit) private var monospacedDigit
  @Environment(\.timeInputViewTwentyFourHour) private var _twentyFourHour
  @Environment(\.timeInputViewTwentyFourHourIndicator) private var twentyFourHourIndicator
  @Environment(\.timeInputViewSelectionTint) private var selectionTint

  private var twentyFourHour: Bool { _twentyFourHour ?? locale.uses24HourTime }

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

  @AccessibilityFocusState private var accessibilityFocusedComponent: Component?
  @State private var focusedComponent = Component.hour
  @State private var hour = 0
  @State private var minute = 0
  private var hourSubject = PassthroughSubject<Int, Never>()
  private var minuteSubject = PassthroughSubject<Int, Never>()
  private var debouncedHour: AnyPublisher<Int, Never>
  private var debouncedMinute: AnyPublisher<Int, Never>
  private var hourBinding: Binding<Double> { Binding { Double(hour) } set: { hour = Int($0) } }
  private var minuteBinding: Binding<Double> { Binding { Double(minute) } set: { minute = Int($0) } }
  private var hourMultiple: Int { twentyFourHour == true ? 24 : 12 }
  private var minuteMultiple: Int { 60 }
  private var normalizedHour: Int { (hour < 0 ? hourMultiple - (abs(hour) % hourMultiple) : hour) % hourMultiple }
  private var normalizedMinute: Int { (minute < 0 ? minuteMultiple - (abs(minute) % minuteMultiple) : minute) % minuteMultiple }

  private var formattedHour: Text {
    Text(
      twentyFourHour == true ? normalizedHour : normalizedHour == 0 ? hourMultiple : normalizedHour,
      format: .number.precision(.integerLength(2...2))
    )
  }

  private var formattedMinute: Text {
    Text(normalizedMinute, format: .number.precision(.integerLength(2...2)))
  }

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
    debouncedHour = hourSubject.removeDuplicates().debounce(for: 0.1, scheduler: RunLoop.main).eraseToAnyPublisher()
    debouncedMinute = minuteSubject.removeDuplicates().debounce(for: 0.1, scheduler: RunLoop.main).eraseToAnyPublisher()
    _hour = State(initialValue: Calendar.current.component(.hour, from: self.selection))
    _minute = State(initialValue: Calendar.current.component(.minute, from: self.selection))
  }

  /// The content and behavior of the view.
  public var body: some View {
    ZStack {
      clockFace
        .accessibilityHidden(true)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.clockFacePadding)
        //.drawingGroup(opaque: true)

      amPMButtons

      pickerButtons
    }
    .environment(\.layoutDirection, .leftToRight)
    .onChange(of: hour) { hourSubject.send($0) }
    .onChange(of: minute) { minuteSubject.send($0) }
    .onChange(of: hourPeriod) { _ in selection = newSelection }
    .onReceive(debouncedHour) { _ in selection = newSelection }
    .onReceive(debouncedMinute) { _ in selection = newSelection }
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

  private func labels(with geometry: GeometryProxy) -> some View {
    switch focusedComponent {
    case .hour:
      if twentyFourHour == true {
        return ForEach(0..<12) { index in
          label(Int(index * 2), at: index, with: geometry, zeroPadded: true)
        }
      } else {
        return ForEach(0..<12) { index in
          label(Int(index == 0 ? 12 : index), at: index, with: geometry)
        }
      }

    case .minute:
      return ForEach(0..<12) { index in
        label(Int(index * 5), at: index, with: geometry, zeroPadded: true)
      }
    }
  }

  private static let offsetLabels = [1, 2, 3, 4, 5, 7, 8, 9].map(String.init)

  private func label(_ value: Int, at index: Int, with geometry: GeometryProxy, zeroPadded: Bool = false) -> some View {
    ZStack {
      Text(value, format: .number.precision(.integerLength((zeroPadded ? 2 : 1)...2)))
        .rotationEffect(.degrees(-Double(index) * 360 / 12), anchor: .center)
        .padding(.bottom, geometry.size.height * (Self.offsetLabels.contains(value.formatted(.number.precision(.integerLength((zeroPadded ? 2 : 1)...2)))) ? 0.62 : 0.59))
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
    let size: CGSize = heavy ? .heavyMarkSize : .markSize

    return Rectangle()
      .size(size)
      .offset(x: -size.width / 2.0, y: 0)
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

    // TODO: bring back fully customizable selection indicator in watchOS 9 using `AnyShape`
    // return self.selectionIndicator!
    //   .offset(y: geometry.size.height / 3)
    //   .rotationEffect(.degrees(180 + rotationDegrees), anchor: .topLeading)
    //   .animation(.spring(), value: value)
    //   .position(x: geometry.size.width, y: geometry.size.height)
  }

  private var twentyFourHourIndicatorString: AttributedString {
    var string = Measurement(value: 24, unit: UnitDuration.hours)
      .formatted(.measurement(width: .abbreviated).locale(locale).attributed)

    string.runs.forEach { run in
      if run.numberPart != nil {
        string[run.range].swiftUI.font = .system(size: 17, weight: .regular)
      }
    }

    string.foregroundColor = .primary.opacity(0.5)

    return string
  }

  private var twentyFourHourIndicatorView: some View {
    //Button(action: {}) {
      Text(twentyFourHourIndicatorString)
        .font(.system(size: 13, weight: .regular))
        //.foregroundColor(.primary.opacity(0.5))
        .textCase(.uppercase)
    //}
    //.buttonStyle(.timePeriod(isHighlighted: false))
    //.disabled(true)
    .opacity(twentyFourHourIndicator != .hidden ? 1 : 0)
  }

  private var localizedHourPeriodSymbol: String {
    switch hourPeriod {
    case .am: return locale.calendar.amSymbol
    case .pm: return locale.calendar.pmSymbol
    }
  }

  private var hourButtonAccessibilityValue: Text {
    Text("\(normalizedHour) o’clock \(twentyFourHour ? "" : localizedHourPeriodSymbol)", bundle: .module)
  }

  private var minuteButtonAccessibilityValue: Text {
    let now = Date.now
    let later = now + TimeInterval(normalizedMinute * minuteMultiple)
    return Text(now..<later, format: .components(style: .spellOut))
  }

  private var amPMButtons: some View {
    VStack {
      Spacer()

      if twentyFourHour == true {
        twentyFourHourIndicatorView
      } else {
        Button(action: { setHourPeriod(.am) }) {
          Text(verbatim: locale.calendar.amSymbol)
            .tracking(locale.calendar.amSymbol == "AM" ? -0.5 : 0)
        }
        .accessibilityAddTraits(hourPeriod == .am ? .isSelected : [])
        .buttonStyle(.timePeriod(isHighlighted: hourPeriod == .am))
      }

      Spacer(minLength: .timeComponentButtonHeight + 8)

      if twentyFourHour == true {
        twentyFourHourIndicatorView
          .opacity(0)
      } else {
        Button(action: { setHourPeriod(.pm) }) {
          Text(verbatim: locale.calendar.pmSymbol)
            .tracking(locale.calendar.pmSymbol == "PM" ? -0.6 : 0)
        }
        .accessibilityAddTraits(hourPeriod == .pm ? .isSelected : [])
        .buttonStyle(.timePeriod(isHighlighted: hourPeriod == .pm))
        .disabled(twentyFourHour == true)
        .opacity(twentyFourHour == true ? 0 : 1)
      }

      Spacer()
    }
  }

  private var pickerButtons: some View {
    HStack(alignment: .firstTextBaseline) {
      Button(action: { focusedComponent = .hour }) { formattedHour }
        .buttonStyle(.timeComponent(isFocused: focusedComponent == .hour))
        .focusable()
        .accessibilityLabel("")
        .accessibilityValue(hourButtonAccessibilityValue)
        .accessibilityAddTraits(.updatesFrequently)
        .accessibilityRemoveTraits(.isButton)
        .accessibilityFocused($accessibilityFocusedComponent, equals: .hour)
        .accessibilityAdjustableAction { direction in
          switch direction {
          case .increment: hour += 1
          case .decrement: hour -= 1
          @unknown default: break
          }
        }
        .digitalCrownRotation(
          hourBinding,
          from: -.greatestFiniteMagnitude,
          through: .greatestFiniteMagnitude,
          by: nil,
          sensitivity: .low,
          isContinuous: true,
          isHapticFeedbackEnabled: true
        )

      Text(locale.timeSeparator)
        .accessibilityHidden(true)
//        .padding(.bottom, 7)
//        .padding(.horizontal, -1)

      Button(action: { focusedComponent = .minute }) { formattedMinute }
        .buttonStyle(.timeComponent(isFocused: focusedComponent == .minute))
        .focusable()
        .accessibilityLabel("")
        .accessibilityValue(minuteButtonAccessibilityValue)
        .accessibilityAddTraits(.updatesFrequently)
        .accessibilityRemoveTraits(.isButton)
        .accessibilityFocused($accessibilityFocusedComponent, equals: .minute)
        .accessibilityAdjustableAction { direction in
          switch direction {
          case .increment: minute += 1
          case .decrement: minute -= 1
          @unknown default: break
          }
        }
        .digitalCrownRotation(
          minuteBinding,
          from: -.greatestFiniteMagnitude,
          through: .greatestFiniteMagnitude,
          by: nil,
          sensitivity: .medium,
          isContinuous: true,
          isHapticFeedbackEnabled: true
        )
    }
    .font(
      monospacedDigit == true
      ? .system(size: .componentFontSize).monospacedDigit()
      : .system(size: .componentFontSize)
    )
    .onChange(of: accessibilityFocusedComponent) {
      if let component = $0 { focusedComponent = component }
    }
  }
}

@available(macOS, unavailable)
@available(iOS, unavailable)
@available(tvOS, unavailable)
struct TimeInputView_Previews: PreviewProvider {
  struct Example: View {
    @State var date = Calendar.current.date(bySettingHour: 10, minute: 09, second: 0, of: Date())!
    var body: some View { TimeInputView(selection: $date) }
  }

  static var previews: some View {
    Group {
      Example()
        .previewDisplayName("Default")

      Example()
        .timeInputViewTwentyFourHour()
        .previewDisplayName("24 hr")

      Example()
        .environment(\.locale, Locale(identifier: "fi"))
        .previewDisplayName("Finnish")

      Example()
        .environment(\.locale, Locale(identifier: "sv"))
        .previewDisplayName("Swedish")

      Example()
        .environment(\.locale, Locale(identifier: "ar"))
        .previewDisplayName("Arabic")

      Example()
        .environment(\.locale, Locale(identifier: "de"))
        .previewDisplayName("German")

      Example()
        .environment(\.locale, Locale(identifier: "he"))
        .previewDisplayName("Hebrew")

      Example()
        .tint(.pink)
        .previewDisplayName("Pink")
    }
    .ignoresSafeArea(edges: .bottom)
    .padding(-10)
    .tint(.orange)
    //.previewLayout(.sizeThatFits)
  }
}
