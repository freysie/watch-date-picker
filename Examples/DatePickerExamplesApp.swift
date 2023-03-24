import SwiftUI
import WatchKit
@testable import WatchDatePicker

// TODO: do something about the `NavigationView`-within-`TabView` situation

@main
struct DatePickerExamplesApp: App {
  var body: some Scene {
    WindowGroup {
      DatePickerExamples_Previews.previews
      // VariousExample()
    }
  }
}

// let screenshotDate = Calendar.current.date // Calendar.current.date(bySettingHour: 10, minute: 09, second: 0, of: Date())!

let monthsAgo = Calendar.current.date(byAdding: .month, value: -3, to: Date())!
let monthsFromNow = Calendar.current.date(byAdding: .month, value: 3, to: Date())!

struct SystemTimeInputView: View {
  @State var coordinator: Coordinator!
  @State var timeInputView: AnyObject!
  @Environment(\.dismiss) var dismiss

  var body: some View {
    VStack {}
      .watchStatusBar(hidden: true)
      .onAppear {
        let PUICTimeInputView = objc_getClass("PUICTimeInputView") as! NSObject.Type

        // do {
        //   var outCount: UInt32 = 0
        //   let methods: UnsafeMutablePointer<objc_property_t>! =  class_copyPropertyList(PUICTimeInputView, &outCount)
        //   let count = Int(outCount)
        //   for i in 0...(count - 1) {
        //     let property: objc_property_t = methods[i]
        //     print(String(utf8String: property_getName(property)) as Any)
        //   }
        // }
        
        // do {
        //   var outCount: UInt32 = 0
        //   let methods: UnsafeMutablePointer<Method>! = class_copyMethodList(PUICTimeInputView, &outCount)
        //   let count = Int(outCount)
        //   for i in 0...(count - 1) {
        //     let method: Method = methods[i]
        //     print(method_getName(method))
        //   }
        // }

        timeInputView = PUICTimeInputView.perform(Selector(String(["n", "e", "w"]))).takeUnretainedValue()

        // print(timeInputView.value(forKey: "circularPrimaryButton") as Any)
        // print(timeInputView.value(forKey: "circularSecondaryButton") as Any)

        timeInputView.setValue(10, forKey: "hour")
        timeInputView.setValue(09, forKey: "minute")

        coordinator = Coordinator(parent: self)
        // timeInputView.setValue(false, forKey: "shouldUseCircularBottomButtons")
        timeInputView.setValue(coordinator, forKey: "delegate")

        let UIApp = objc_getClass("UIApplication") as! NSObject.Type
        let app = UIApp.perform(Selector(("shared" + "Application"))).takeUnretainedValue()
        let keyWindow = app.perform(Selector(("keyWindow"))).takeUnretainedValue()

        let frame = keyWindow.value(forKey: "frame")
        timeInputView.setValue(frame, forKey: "frame")
        // timeInputView.setValue(CGRect(x: 20, y: 20, width: 150, height: 150), forKey: "frame")

        _ = keyWindow.perform(Selector(("addSubview:")), with: timeInputView)

        // print(timeInputView.value(forKey: "debugDescription") as Any)
      }
      .onDisappear {
        _ = timeInputView?.perform(Selector(("removeFromSuperview")))
      }
  }
  
  class Coordinator: NSObject, ObservableObject {
    var parent: SystemTimeInputView
    init(parent: SystemTimeInputView) { self.parent = parent }
    
    @objc func cancelButtonTapped(_ sender: AnyObject) { parent.dismiss() }
    @objc func setButtonTapped(_ sender: AnyObject) { parent.dismiss() }
  }
}

struct VariousExample: View {
  @State var sheetIsPresented = false
  @State var value = Calendar.current.date(bySettingHour: 10, minute: 09, second: 0, of: Date())!

  var body: some View {
    NavigationView {
      Form {
        Button("System Time Input View") {
          sheetIsPresented = true
        }
        .sheet(isPresented: $sheetIsPresented) {
          SystemTimeInputView()
            .navigationBarHidden(true)
        }
        
        DatePicker("Time (Pink)", selection: $value, displayedComponents: [.hourAndMinute])
          .tint(.pink)

        DatePicker("Time (Finnish)", selection: $value, displayedComponents: [.hourAndMinute])
          .tint(.pink)
          .environment(\.locale, Locale(identifier: "fi"))

        DatePicker("Date & Time", selection: $value)
        
        DatePicker("Date", selection: $value, displayedComponents: [.date])
        
        // DatePicker("Time (Push)", selection: $value, displayedComponents: [.hourAndMinute])
        //   .datePickerInteractionStyle(.navigationLink)
      }
    }
  }
}

struct SimpleDateAndTimeExample: View {
  @State var value = Calendar.current.date(bySettingHour: 10, minute: 09, second: 0, of: Date())!
  
  var body: some View {
    Form {
      DatePicker("Date & Time", selection: $value)
    }
  }
}

struct SimpleDateExample: View {
  @State var value = Calendar.current.date(bySettingHour: 10, minute: 09, second: 0, of: Date())!
  
  var body: some View {
    Form {
      DatePicker("Date", selection: $value, displayedComponents: [.date])
    }
  }
}

struct SimpleTimeExample: View {
  @State var value = Calendar.current.date(bySettingHour: 10, minute: 09, second: 0, of: Date())!
  
  var body: some View {
    Form {
      DatePicker("Time", selection: $value, displayedComponents: [.hourAndMinute])

      DatePicker("Time (Pink)", selection: $value, displayedComponents: [.hourAndMinute])
        .tint(.pink)
    }
  }
}

struct SimpleDateInputViewExamples: View {
  @State var value = Calendar.current.date(bySettingHour: 10, minute: 09, second: 0, of: Date())!
  
  var body: some View {
    DateInputView(selection: $value)
  }
}

struct SimpleTimeInputViewExamples: View {
  @State var value = Calendar.current.date(bySettingHour: 10, minute: 09, second: 0, of: Date())!
  
  var body: some View {
    TimeInputView(selection: $value)
      .edgesIgnoringSafeArea(.bottom)
      .padding(-10)
  }
}

struct DateAndTimeExamples: View {
  @State var value = Calendar.current.date(bySettingHour: 10, minute: 09, second: 0, of: Date())!
  
  var body: some View {
    Form {
      DatePicker("Date & Time", selection: $value)
      
      DatePicker("Date & Time (24h)", selection: $value)
        .timeInputViewTwentyFourHour()
      
      DatePicker(selection: $value) {
        Label("_Custom_ Label", systemImage: "clock")
          .symbolVariant(.fill)
          .tint(.orange)
      }
      
      DatePicker(String("String Label"), selection: $value)
      
      DatePicker("Change Time", selection: $value)
        .datePickerFlipsLabelAndValue()
    }
  }
}

struct DateExamples: View {
  @State var value = Calendar.current.date(bySettingHour: 10, minute: 09, second: 0, of: Date())!
  
  var body: some View {
    Form {
      DatePicker("Date", selection: $value, displayedComponents: [.date])
      
      DatePicker("Date (Min)", selection: $value, in: Date()..., displayedComponents: [.date])
      
      DatePicker("Date (Max)", selection: $value, in: ...Date(), displayedComponents: [.date])
      
      DatePicker("Date (Min & Max)", selection: $value, in: monthsAgo...monthsFromNow, displayedComponents: [.date])
    }
  }
}

struct TimeExamples: View {
  @State var value = Calendar.current.date(bySettingHour: 10, minute: 09, second: 0, of: Date())!
  
  var body: some View {
    Form {
      DatePicker("Time", selection: $value, displayedComponents: [.hourAndMinute])
      
      DatePicker("Time (24h)", selection: $value, displayedComponents: [.hourAndMinute])
        .timeInputViewTwentyFourHour()
    }
  }
}

struct DateInputViewExamples: View {
  @State var value = Calendar.current.date(bySettingHour: 10, minute: 09, second: 0, of: Date())!
  
  @Environment(\.locale) var locale
  
  var formattedDateSelection: String {
    let formatter = DateFormatter()
    formatter.locale = locale
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    return formatter.string(from: value)
  }
  
  var body: some View {
    DateInputView(selection: $value)
      .navigationTitle(formattedDateSelection)
    
    DateInputView(selection: $value)
      .navigationTitle(formattedDateSelection)
      .environment(\.locale, Locale(identifier: "fr"))
    
    DateInputView(selection: $value)
      .navigationTitle(formattedDateSelection)
      .environment(\.locale, Locale(identifier: "sv"))
    
    DateInputView(selection: $value)
      .navigationTitle(formattedDateSelection)
      .environment(\.locale, Locale(identifier: "en_CA"))
  }
}

struct TimeInputViewExamples: View {
  @State var value = Calendar.current.date(bySettingHour: 10, minute: 09, second: 0, of: Date())!
  
  @Environment(\.locale) var locale
  
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
    Group {
      TimeInputView(selection: $value)
        .navigationTitle(formattedTimeSelection)
      
      TimeInputView(selection: $value)
        .navigationTitle(formattedTimeSelection)
        .timeInputViewMonospacedDigit()
      
      TimeInputView(selection: $value)
        .navigationTitle(formatted24HourTimeSelection)
        .environment(\.locale, Locale(identifier: "da"))
      
      TimeInputView(selection: $value)
        .navigationTitle(formatted24HourTimeSelection)
        .timeInputViewTwentyFourHour()
      
      TimeInputView(selection: $value)
        .navigationTitle(formatted24HourTimeSelection)
        .timeInputViewTwentyFourHour()
        .timeInputViewTwentyFourHourIndicator(.hidden)
      
      TimeInputView(selection: $value)
        .navigationTitle(formattedTimeSelection)
        .environment(\.locale, Locale(identifier: "sv"))
        .timeInputViewTwentyFourHour(false)
      
      TimeInputView(selection: $value)
        .navigationTitle(formattedTimeSelection)
        .tint(.pink)
      
      TimeInputView(selection: $value)
        .navigationTitle(formattedTimeSelection)
        .tint(.pink)
        .timeInputViewFocusTint(.pink)
      
      TimeInputView(selection: $value)
        .navigationTitle(formattedTimeSelection)
        .tint(.red)
        .timeInputViewAMPMHighlightTint(.brown)
        .timeInputViewSelectionTint(.indigo)
        .timeInputViewFocusTint(.pink)
    }
    .edgesIgnoringSafeArea(.bottom)
    .padding(-10)
  }
}

struct NavigationExamples: View {
  @State var value = Calendar.current.date(bySettingHour: 10, minute: 09, second: 0, of: Date())!
  @State var sheetIsPresented = false
  @State var fullScreenCoverIsPresented = false
  
  var body: some View {
    NavigationView {
      Form {
        Button("Open Sheet", action: { sheetIsPresented.toggle() })
          .sheet(isPresented: $sheetIsPresented) {
            Form {
              DatePicker("Date & Time", selection: $value)
              DatePicker("Date", selection: $value, displayedComponents: [.date])
              DatePicker("Time", selection: $value, displayedComponents: [.hourAndMinute])
            }
          }
        
        Button("Open Full-Screen Cover", action: { fullScreenCoverIsPresented.toggle() })
          .fullScreenCover(isPresented: $fullScreenCoverIsPresented) {
            Form {
              DatePicker("Date & Time", selection: $value)
              DatePicker("Date", selection: $value, displayedComponents: [.date])
              DatePicker("Time", selection: $value, displayedComponents: [.hourAndMinute])
            }
          }
        
        NavigationLink("Push View") {
          Form {
            DatePicker("Date & Time", selection: $value)
            DatePicker("Date", selection: $value, displayedComponents: [.date])
            DatePicker("Time", selection: $value, displayedComponents: [.hourAndMinute])
          }
        }
      }
    }
  }
}

struct DatePickerExamples_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      TabView {
        VariousExample()

        Group {
          SimpleDateAndTimeExample()
          SimpleDateExample()
          SimpleTimeExample()

          SimpleDateInputViewExamples()
          SimpleTimeInputViewExamples()
        }

        Group {
          DateAndTimeExamples()
          DateExamples()
          TimeExamples()

          DateInputViewExamples()
          TimeInputViewExamples()

          NavigationExamples()
        }
      }
      .tint(.orange)
      .tabViewStyle(.page(indexDisplayMode: .never))
    }
    .previewDevice(PreviewDevice(rawValue: "Apple Watch Series 6 - 44mm"))
  }
}

// Form {
//   Group {
//     Button("click") { WKInterfaceDevice.current().play(.click) }
//     Button("directionDown") { WKInterfaceDevice.current().play(.directionDown) }
//     Button("directionUp") { WKInterfaceDevice.current().play(.directionUp) }
//   }
//   Button("failure") { WKInterfaceDevice.current().play(.failure) }
//   Button("navigationGenericManeuver") { WKInterfaceDevice.current().play(.navigationGenericManeuver) }
//   Button("navigationLeftTurn") { WKInterfaceDevice.current().play(.navigationLeftTurn) }
//   Button("navigationRightTurn") { WKInterfaceDevice.current().play(.navigationRightTurn) }
//   Button("notification") { WKInterfaceDevice.current().play(.notification) }
//   Button("retry") { WKInterfaceDevice.current().play(.retry) }
//   Button("start") { WKInterfaceDevice.current().play(.start) }
//   Button("stop") { WKInterfaceDevice.current().play(.stop) }
//   Button("success") { WKInterfaceDevice.current().play(.success) }
// }
