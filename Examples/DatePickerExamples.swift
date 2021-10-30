//#if os(watchOS)

import SwiftUI

struct DatePickerExamples: View {
  @State var value0 = Calendar.current.date(bySettingHour: 10, minute: 09, second: 0, of: Date())!
  @State var value1 = Calendar.current.date(bySettingHour: 10, minute: 09, second: 0, of: Date())!
  @State var value2 = Calendar.current.date(bySettingHour: 10, minute: 09, second: 0, of: Date())!
  @State var value3 = Calendar.current.date(bySettingHour: 10, minute: 09, second: 0, of: Date())!
  
  var body: some View {
    TabView {
      NavigationView {
        TimePickerView(
          twentyFourHour: true,
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

      Form {
        DatePicker("Date & Time", selection: $value1, onCompletion: { value1 = $0 })
      }
      
      Form {
        WatchDatePicker.DatePicker(
          "Date",
          selection: $value2,
          mode: .date,
          maximumDate: Date(),
          onCompletion: { value2 = $0 }
        )
      }
      
      Form {
        DatePicker(
          "Time",
          selection: $value3,
          mode: .time,
          twentyFourHour: true,
          onCompletion: { value3 = $0 }
        )
      }
      
      NavigationView {
        DatePickerView()
      }
      
      NavigationView {
        DatePickerView(mode: .date)
          .environment(\.locale, Locale(identifier: "fr"))
      }
      
      NavigationView {
        DatePickerView(mode: .date, confirmationTitleKey: "Yaaas", confirmationColor: .mint)
          .environment(\.locale, Locale(identifier: "ja"))
      }
      
      NavigationView {
        TimePickerView(
          selectionIndicatorRadius: 5,
          selectionIndicatorColor: .brown,
          focusColor: .purple,
          amPMHighlightColor: .brown
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
