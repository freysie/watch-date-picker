#if os(watchOS)

import SwiftUI
import Combine

/// A control for the inputting of time values.
///
/// The `TimeInputView` displays a clock face interface that allows the user to select hour and minute. The view binds to a `Date` instance.
///
/// ![](TimeInputView.png)
@available(watchOS 8, *)
public struct TimeInputView: View {
  @Binding private var underlyingSelection: Date?
  private var selection: Date { underlyingSelection ?? .nextHour }
  private let initialSelection: Date

  @Environment(\.locale) private var locale
  @Environment(\.timeInputViewMonospacedDigit) private var monospacedDigit
  @Environment(\.timeInputViewTwentyFourHour) private var environmentTwentyFourHour
  @Environment(\.timeInputViewForHourOnly) private var environmentForHourOnly
  @Environment(\.timeInputViewTwentyFourHourIndicator) private var twentyFourHourIndicatorVisibility
  @Environment(\.timeInputViewSelectionTint) private var selectionTint

  @State private var twentyFourHour = false
  @State private var timeSeparator = ":"

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

  @State private var focusedComponent = Component.hour
  @FocusState private var systemFocusedComponent: Component?
  @AccessibilityFocusState private var accessibilityFocusedComponent: Component?

  @State private var hour = 0
  @State private var minute = 0

  private var selectionPublisher = PassthroughSubject<Void, Never>()

  private var hourBinding: Binding<Double> { Binding { Double(hour) } set: { print($0); hour = Int($0) } }
  private var minuteBinding: Binding<Double> { Binding { Double(minute) } set: { minute = Int($0) } }

  private var hourMultiple: Int { twentyFourHour ? 24 : 12 }
  private var minuteMultiple: Int { 60 }

  private var normalizedHour: Int { (hour < 0 ? hourMultiple - (abs(hour) % hourMultiple) : hour) % hourMultiple }
  private var normalizedMinute: Int { (minute < 0 ? minuteMultiple - (abs(minute) % minuteMultiple) : minute) % minuteMultiple }

  private var hourPeriod: HourPeriod {
    get { abs(hour < 0 ? hour - 12 : hour) % 24 < 12 ? .am : .pm }
  }

  private func setHourPeriod(_ period: HourPeriod) {
    guard hourPeriod != period else { return }
    var t = Transaction()
    t.disablesAnimations = true
    withTransaction(t) { hour += period.sign }
  }

  private var formattedHour: Text {
    let hour = twentyFourHour ? normalizedHour : normalizedHour == 0 ? hourMultiple : normalizedHour
    return Text(hour, format: .number.precision(.integerLength(2...2)))
  }

  private var formattedMinute: Text {
    Text(normalizedMinute, format: .number.precision(.integerLength(2...2)))
  }

  private var newSelection: Date {
    guard let result = locale.calendar.date(
      bySettingHour: normalizedHour + (twentyFourHour ? 0 : hourPeriod.offset),
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
  ///   - selection: The date value being displayed and selected.
  public init(selection: Binding<Date>) {
    self.init(selection: Binding(selection))
  }

  /// Creates a time input view instance with the specified properties.
  /// - Parameters:
  ///   - selection: The optional date value being displayed and selected.
  public init(selection: Binding<Date?>) {
    _underlyingSelection = selection
    initialSelection = selection.wrappedValue ?? .now
    focusedComponent = .hour

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

      if !twentyFourHour {
        amPMButtons
      }

      pickerButtons
        .overlay(alignment: .top) {
          if twentyFourHour { twentyFourHourIndicator }
        }
    }
    .accessibilityElement(children: isTakingScreenshots ? .contain : .ignore)
    .environment(\.layoutDirection, .leftToRight)
    .onChange(of: hour) { _ in selectionPublisher.send() }
    .onChange(of: minute) { _ in selectionPublisher.send() }
    .onChange(of: hourPeriod) { _ in selectionPublisher.send() }
    .onReceive(selectionPublisher.debounce(for: 0.15, scheduler: RunLoop.main)) { _ in
      underlyingSelection = newSelection
    }
    .onAppear {
      twentyFourHour = environmentTwentyFourHour ?? locale.uses24HourTime
      timeSeparator = locale.timeSeparator
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

  private func labels(with geometry: GeometryProxy) -> some View {
    switch focusedComponent {
    case .hour:
      if twentyFourHour {
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
        .padding(.bottom, geometry.size.height * (Self.offsetLabels.contains(value.formatted(.number.precision(.integerLength((zeroPadded ? 2 : 1)...2)))) ? 0.62 : 0.6))
    }
    .rotationEffect(.degrees(Double(index) * 360 / 12), anchor: .center)
    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
    .font(.system(size: 15))
  }

  private func marks(for component: Component, with geometry: GeometryProxy) -> some View {
    if twentyFourHour && component == .hour {
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
        string[run.range].swiftUI.font = .system(size: 16.5, weight: .regular)
      }
    }

    string.foregroundColor = .primary.opacity(0.45)

    return string
  }

  private var twentyFourHourIndicator: some View {
    Text(twentyFourHourIndicatorString)
      .font(.system(size: 12.5, weight: .regular))
      .textCase(.uppercase)
      .opacity(twentyFourHourIndicatorVisibility != .hidden ? 1 : 0)
      .offset(y: .twentyFourHourIndicatorOffset)
  }

  private var localizedHourPeriodSymbol: String {
    switch hourPeriod {
    case .am: return locale.calendar.amSymbol
    case .pm: return locale.calendar.pmSymbol
    }
  }

  private var hourButtonAccessibilityValue: Text {
    let hour = normalizedHour == 0 ? 12 : normalizedHour
    let amPM = twentyFourHour ? "" : localizedHourPeriodSymbol
    return Text("\(hour) o’clock \(amPM)", bundle: .module)
  }

  private var minuteButtonAccessibilityValue: Text {
    let now = Date()
    let later = now + TimeInterval(normalizedMinute * minuteMultiple)
    return Text(now..<later, format: .components(style: .spellOut))
  }

  private var amPMButtons: some View {
    VStack(spacing: 0) {
      Spacer()

      Button(action: { setHourPeriod(.am) }) {
        Text(verbatim: locale.calendar.amSymbol)
          .tracking(locale.calendar.amSymbol == "AM" ? -0.5 : 0)
      }
      .accessibilityAddTraits(hourPeriod == .am ? .isSelected : [])
      .buttonStyle(.timePeriod(isHighlighted: hourPeriod == .am))

      Spacer(minLength: .timeComponentButtonHeight + 16)

      Button(action: { setHourPeriod(.pm) }) {
        Text(verbatim: locale.calendar.pmSymbol)
          .tracking(locale.calendar.pmSymbol == "PM" ? -0.6 : 0)
      }
      .accessibilityAddTraits(hourPeriod == .pm ? .isSelected : [])
      .buttonStyle(.timePeriod(isHighlighted: hourPeriod == .pm))

      Spacer()
    }
  }

  @ViewBuilder private var timeSeparatorView: some View {
#if swift(>=5.7)
    if #available(watchOS 9.1, *) {
      Text(timeSeparator)
        .fontDesign(.default)
        .accessibilityHidden(true)
    } else {
      Text(timeSeparator)
        .accessibilityHidden(true)
    }
#else
    Text(timeSeparator)
      .accessibilityHidden(true)
#endif
  }

  private var pickerButtons: some View {
    HStack(alignment: timeSeparator == "." ? .firstTextBaseline : .top) {
      Button(action: { focusedComponent = .hour }) { formattedHour }
        .buttonStyle(.timeComponent(isFocused: focusedComponent == .hour))
        .focusable()
        .accessibilityLabel("")
        .accessibilityValue(hourButtonAccessibilityValue)
        .accessibilityAddTraits(.updatesFrequently)
        .accessibilityRemoveTraits(.isButton)
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
        .accessibilityFocused($accessibilityFocusedComponent, equals: .hour)
        .focused($systemFocusedComponent, equals: .hour)

      timeSeparatorView

      Button(action: { focusedComponent = .minute }) { formattedMinute }
        .buttonStyle(.timeComponent(isFocused: focusedComponent == .minute))
        .focusable()
        .accessibilityLabel("")
        .accessibilityValue(minuteButtonAccessibilityValue)
        .accessibilityAddTraits(.updatesFrequently)
        .accessibilityRemoveTraits(.isButton)
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
        .accessibilityFocused($accessibilityFocusedComponent, equals: .minute)
        .focused($systemFocusedComponent, equals: .minute)
        .disabled(environmentForHourOnly ?? false)
    }
    .font(
      monospacedDigit == true
      ? .system(size: .componentFontSize).monospacedDigit()
      : .system(size: .componentFontSize)
    )
    .onChange(of: accessibilityFocusedComponent) {
      guard let component = $0 else { return }
      focusedComponent = component
      systemFocusedComponent = component
    }
  }
}

struct TimeInputView_Previews: PreviewProvider {
  // TODO: move to a new view type that can be used both here and in `DatePicker`
  struct Example: View {
    @State var date = Calendar.current.date(bySettingHour: 10, minute: 09, second: 0, of: Date())!
    @Environment(\.datePickerConfirmationTint) var confirmationTint

    var body: some View {
      ZStack(alignment: .bottom) {
        TimeInputView(selection: $date)
          .offset(y: 10)

        circularButtons
          .padding(.bottom, .hourAndMinuteCircularButtonsBottomPadding)
          .padding(.horizontal, .hourAndMinuteCircularButtonsHorizontalPadding)
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .navigationBarHidden(true)
      .watchStatusBar(hidden: true)
      ._statusBar(hidden: true)
      .edgesIgnoringSafeArea(.all)
      .padding(.bottom, -40)
      .padding(.horizontal, -32)
      .offset(y: -45)
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
        .environment(\.layoutDirection, .rightToLeft)
        .previewDisplayName("Arabic")

      Example()
        .environment(\.locale, Locale(identifier: "de"))
        .previewDisplayName("German")

      Example()
        .environment(\.locale, Locale(identifier: "he"))
        .environment(\.layoutDirection, .rightToLeft)
        .previewDisplayName("Hebrew")

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
