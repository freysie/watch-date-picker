import SwiftUI
import WatchDatePicker

@main
struct DatePickerExamplesApp: App {
  var body: some Scene {
    WindowGroup {
      NavigationView {
        DatePickerExamples()
      }
    }
  }
}

struct DatePickerExamples: View {
  @State var value = Calendar.current.date(bySettingHour: 10, minute: 09, second: 0, of: Date())!

  @Environment(\.locale) var locale

  var formattedDateSelection: String {
    let formatter = DateFormatter()
    formatter.locale = locale
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    return formatter.string(from: value)
  }

  var formattedTimeSelection: String {
    let formatter = DateFormatter()
    formatter.locale = locale
    formatter.dateStyle = .none
    formatter.timeStyle = .medium
    return formatter.string(from: value)
  }

  var formatted24HourTimeSelection: String {
    let formatter = DateFormatter()
    formatter.locale = locale
    formatter.dateFormat = "HH:mm:ss"
    return formatter.string(from: value)
  }

  var body: some View {
    TabView {
      Form {
        DatePicker("Date & Time", selection: $value)

        DatePicker("Date & Time (24h)", selection: $value)
          .datePickerTwentyFourHour()
      }

      Form {
        DatePicker("Date", selection: $value, displayedComponents: [.date])

        DatePicker("Date (Min)", selection: $value, in: Date()..., displayedComponents: [.date])

        DatePicker("Date (Max)", selection: $value, in: ...Date(), displayedComponents: [.date])
      }

      Form {
        DatePicker("Time", selection: $value, displayedComponents: [.hourAndMinute])

        DatePicker("Time (24h)", selection: $value, displayedComponents: [.hourAndMinute])
          .datePickerTwentyFourHour()
      }

      DateInputView(selection: $value)
        .navigationTitle(formattedDateSelection)

      TimeInputView(selection: $value)
        .navigationTitle(formattedTimeSelection)

      TimeInputView(selection: $value)
        .navigationTitle(formatted24HourTimeSelection)
        .datePickerTwentyFourHour()
    }
    .tint(.orange)
    .tabViewStyle(.page(indexDisplayMode: .never))
  }
}

struct DatePickerExamples_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      DatePickerExamples()
    }
    .previewDevice(PreviewDevice(rawValue: "Apple Watch Series 6 - 44mm"))
  }
}
