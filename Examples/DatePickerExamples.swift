//import SwiftUI
//import WatchDatePicker
//
//struct DatePickerExamples: View {
//  @State var value = Calendar.current.date(bySettingHour: 10, minute: 09, second: 0, of: Date())!
//
//  var body: some View {
//    TabView {
//      Form {
//        TimePicker()
//
//        TimePicker()
//          .timeInputViewTwentyFourHour()
//
//        TimePicker()
//          .timeInputViewTwentyFourHour()
//          .timeInputViewTwentyFourHourIndicator(.hidden)
//      }
//      
//      //      NavigationView {
//      TimeInputView(selection: $value)
//        .datePickerFocusTint(.purple)
//        .datePickerAMPMHighlightTint(.yellow)
//        .datePickerMarkSize(CGSize(width: 5.5, height: 3))
//        .datePickerMarkFill(.white.opacity(0.75))
//        .datePickerHeavyMarkSize(CGSize(width: 2, height: 7))
//        .datePickerHeavyMarkFill(.pink)
//        .datePickerSelectionIndicatorRadius(7)
//        .datePickerSelectionIndicatorFill(.mint)
//        .ignoresSafeArea()
//      
//      //        .datePickerSelectionIndicator {
//      //          Circle()
//      //            .size(width: 14, height: 14)
//      //            .fill(.mint)
//      //        }
//      //        .datePickerMark {
//      //          Rectangle()
//      //            .size(width: 5.5, height: 3)
//      //            .fill(.white.opacity(0.75))
//      //        }
//      //        .datePickerHeavyMark {
//      //          Rectangle()
//      //            .size(width: 2, height: 7)
//      //            .fill(.pink)
//      //        }
//      
//      //          .offset(y: 5)
//      //      }
//
//      Form {
//        DatePicker("Date & Time", selection: $value)
//
//        DatePicker("Date & Time (24h)", selection: $value)
//          .timeInputViewTwentyFourHour()
//      }
//      
//      Form {
//        DatePicker("Date", selection: $value, in: ...Date(), displayedComponents: [.date])
//      }
//      
//      Form {
//        DatePicker("Time", selection: $value, displayedComponents: [.hourAndMinute])
//
//        DatePicker("Time (24h)", selection: $value, displayedComponents: [.hourAndMinute])
//          .timeInputViewTwentyFourHour()
//      }
//
//      Group {
//        NavigationView {
//          DateInputView(selection: $value)
//        }
//        
//        NavigationView {
//          DateInputView(selection: $value)
//            .dateInputViewShowsMonthBeforeDay(false)
//        }
//        
//        NavigationView {
//          DateInputView(selection: $value)
//            .environment(\.locale, Locale(identifier: "fr"))
//        }
//        
//        NavigationView {
//          DateInputView(selection: $value)
//            .datePickerConfirmationTint(.mint)
//            .datePickerConfirmationTitle("Yaaas")
//            .environment(\.locale, Locale(identifier: "ja"))
//        }
//      }
//
//      NavigationView {
//        TimeInputView(selection: $value)
//          .datePickerFocusTint(.purple)
//          .datePickerAMPMHighlightTint(.brown)
//          .datePickerSelectionIndicatorRadius(5)
//          .datePickerSelectionIndicatorFill(.brown)
////          .offset(y: 5)
//      }
//
//      NavigationView {
//        TimeInputView(selection: $value)
//          .timeInputViewTwentyFourHour()
//          .timeInputViewTwentyFourHourIndicator(.hidden)
//          .datePickerFocusTint(.pink)
//          .datePickerAMPMHighlightTint(.yellow)
//          .datePickerSelectionIndicatorFill(.yellow)
//          .datePickerMarkFill(.pink.opacity(0.25))
//          .datePickerHeavyMarkFill(.pink)
//
////          .offset(y: 5)
//      }
//    }
//    // .tabViewStyle(.page(indexDisplayMode: .never))
//    .tabViewStyle(.page)
//    .accessibilityIdentifier("PageView")
//  }
//}
//
//struct DatePickerExamples_Previews: PreviewProvider {
//  static var previews: some View {
//    NavigationView {
//      DatePickerExamples()
//    }
//    .previewDevice(PreviewDevice(rawValue: "Apple Watch Series 6 - 44mm"))
//  }
//}
