import SwiftUI
import WatchDatePicker

struct DatePickerExamples: View {
  @State var value = Calendar.current.date(bySettingHour: 10, minute: 09, second: 0, of: Date())!

  var body: some View {
    TabView {
      NavigationView {
        TimePickerView(selection: $value)
          .datePickerFocusTint(.purple)
          .datePickerAMPMHighlightTint(.yellow)
          .datePickerMarkSize(CGSize(width: 5.5, height: 3))
          .datePickerMarkFill(.white.opacity(0.75))
          .datePickerHeavyMarkSize(CGSize(width: 2, height: 7))
          .datePickerHeavyMarkFill(.pink)
          .datePickerSelectionIndicatorRadius(7)
          .datePickerSelectionIndicatorFill(.mint)

//        .datePickerSelectionIndicator {
//          Circle()
//            .size(width: 14, height: 14)
//            .fill(.mint)
//        }
//        .datePickerMark {
//          Rectangle()
//            .size(width: 5.5, height: 3)
//            .fill(.white.opacity(0.75))
//        }
//        .datePickerHeavyMark {
//          Rectangle()
//            .size(width: 2, height: 7)
//            .fill(.pink)
//        }
        
//          .offset(y: 5)
      }

      Form {
        WatchDatePicker.DatePicker("Date & Time", selection: $value)
        WatchDatePicker.DatePicker("Date & Time (24h)", selection: $value)
          .datePickerTwentyFourHour()
      }
      
      Form {
        DatePicker("Date", selection: $value, mode: .date, maximumDate: Date())
      }
      
      Form {
        DatePicker("Time", selection: $value, mode: .time)
        DatePicker("Time (24h)", selection: $value, mode: .time)
          .datePickerTwentyFourHour()
      }

      NavigationView {
        DatePickerView(selection: $value)
      }

      NavigationView {
        DatePickerView(selection: $value, mode: .date)
          .datePickerShowsMonthBeforeDay(false)
      }

      NavigationView {
        DatePickerView(selection: $value, mode: .date)
          .environment(\.locale, Locale(identifier: "fr"))
      }

      NavigationView {
        DatePickerView(selection: $value, mode: .date)
          .datePickerConfirmationTint(.mint)
          .datePickerConfirmationTitle("Yaaas")
          .environment(\.locale, Locale(identifier: "ja"))
      }

      NavigationView {
        TimePickerView(selection: $value)
          .datePickerFocusTint(.purple)
          .datePickerAMPMHighlightTint(.brown)
          .datePickerSelectionIndicatorRadius(5)
          .datePickerSelectionIndicatorFill(.brown)
//          .offset(y: 5)
      }

      NavigationView {
        TimePickerView(selection: $value)
          .datePickerTwentyFourHour()
          .datePickerTwentyFourHourIndicator(.hidden)
          .datePickerFocusTint(.pink)
          .datePickerAMPMHighlightTint(.yellow)
          .datePickerSelectionIndicatorFill(.yellow)
          .datePickerMarkFill(.pink.opacity(0.25))
          .datePickerHeavyMarkFill(.pink)

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
