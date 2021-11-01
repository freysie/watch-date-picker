//#if os(watchOS)

import SwiftUI

struct DatePickerExamples: View {
  @State var value = Calendar.current.date(bySettingHour: 10, minute: 09, second: 0, of: Date())!

  var body: some View {
    TabView {
      Form {
        WatchDatePicker.DatePicker("Date & Time", selection: $value, twentyFourHour: false)
        WatchDatePicker.DatePicker("Date & Time (24h)", selection: $value, twentyFourHour: true)
      }
      
      Form {
        DatePicker("Date", selection: $value, mode: .date, maximumDate: Date())
      }
      
      Form {
        DatePicker("Time", selection: $value, mode: .time, twentyFourHour: false)
        DatePicker("Time (24h)", selection: $value, mode: .time, twentyFourHour: true)
      }

      NavigationView {
        DatePickerView(selection: $value)
      }

      NavigationView {
        DatePickerView(selection: $value, mode: .date)
          .environment(\.locale, Locale(identifier: "fr"))
      }

      NavigationView {
        DatePickerView(selection: $value, mode: .date, confirmationTitleKey: "Yaaas", confirmationColor: .mint)
          .environment(\.locale, Locale(identifier: "ja"))
      }

      NavigationView {
        TimePickerView(
          selection: $value,
          selectionIndicatorRadius: 5,
          selectionIndicatorColor: .brown,
          focusColor: .purple,
          amPMHighlightColor: .brown
        )
//          .offset(y: 5)
      }

      NavigationView {
        TimePickerView(
          selection: $value,
          twentyFourHour: true,
          showsTwentyFourHourIndicator: false,
          selectionIndicatorColor: .yellow,
          focusColor: .pink,
          amPMHighlightColor: .yellow,
          markFill: AnyShapeStyle(Color.pink.opacity(0.25)),
          emphasizedMarkFill: AnyShapeStyle(Color.pink)
        )
//          .offset(y: 5)
      }
      
      NavigationView {
        TimePickerView(
          selection: $value,
          selectionIndicatorRadius: 7,
          selectionIndicatorColor: .mint,
          focusColor: .purple,
          amPMHighlightColor: .yellow,
          markSize: CGSize(width: 5.5, height: 3),
          markFill: AnyShapeStyle(Color.white.opacity(0.75)),
          emphasizedMarkSize: CGSize(width: 2, height: 7),
          emphasizedMarkFill: AnyShapeStyle(Color.pink)
        )
//          .offset(y: 5)
      }
    }
    .tabViewStyle(.page(indexDisplayMode: .never))
    .accentColor(.orange)
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

//#endif
