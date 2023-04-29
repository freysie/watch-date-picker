import SwiftUI
import WatchKit
import WatchDatePicker

let isTakingScreenshots = ProcessInfo.processInfo.environment["WDP_SCREENSHOTS"] == "1"

@main
struct DatePickerExamplesApp: App {
  var body: some Scene {
    WindowGroup {
      DatePickerExamples_Previews.previews
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

          SimpleOptionalDateAndTimeExample()
          SimpleOptionalDateExample()
          SimpleOptionalTimeExample()

          SimpleDateInputViewExamples()
          SimpleTimeInputViewExamples()
        }

        // This is where screenshotting ends.

        Group {
          DateAndTimeExamples()
          DateExamples()
          TimeExamples()

          DateInputViewExamples()
          TimeInputViewExamples()

          NavigationExamples()
        }
      }
      .tabViewStyle(.page(indexDisplayMode: .never))
      .datePickerDefaultSelection(defaultSelection)
    }
  }
}

//let screenshotDate = Calendar.current.date(bySettingHour: 10, minute: 09, second: 0, of: .now)!

let year = Calendar.current.component(.year, from: .now)
let screenshotDate = Calendar.current.date(from: DateComponents(year: year, month: 11, day: 30, hour: 10, minute: 09))!
let defaultSelection = Calendar.current.date(from: DateComponents(year: year, month: 11, day: 30, hour: 10, minute: 00))!

let monthsAgo = Calendar.current.date(byAdding: .month, value: -3, to: .now)!
let monthsFromNow = Calendar.current.date(byAdding: .month, value: 3, to: .now)!

struct VariousExample: View {
  @State var systemTimeInputSheetIsPresented = false
  @State var value = screenshotDate
  @State var optionalValue: Date?

  var body: some View {
    NavigationView {
      Form {
        Button("System Time Input View") { systemTimeInputSheetIsPresented = true }
          .sheet(isPresented: $systemTimeInputSheetIsPresented) { SystemTimeInputView().navigationBarHidden(true) }
        
        DatePicker("Time (Pink)", selection: $value, displayedComponents: [.hourAndMinute])
          .tint(.pink)

        Group {
          DatePicker("Optional Date & Time", selection: $optionalValue)
          DatePicker("Optional Date", selection: $optionalValue, displayedComponents: [.date])
          DatePicker("Optional Time", selection: $optionalValue, displayedComponents: [.hourAndMinute])
        }

        DatePicker("Time (Finnish)", selection: $value, displayedComponents: [.hourAndMinute])
          .tint(.pink)
          .environment(\.locale, Locale(identifier: "fi"))

        DatePicker("Date & Time", selection: $value)
        
        DatePicker("Date", selection: $value, displayedComponents: [.date])
          
        DatePicker("Time (Push)", selection: $value, displayedComponents: [.hourAndMinute])
          .datePickerInteractionStyle(.navigationLink)

        DatePicker("Date & Time (Finnish)", selection: $value)
          .environment(\.locale, Locale(identifier: "fi"))

        WebKitDatePicker()
      }
    }
  }
}

struct SimpleDateAndTimeExample: View {
  @State var value = screenshotDate

  var body: some View {
    Form {
      DatePicker("Date & Time", selection: $value)
    }
  }
}

struct SimpleDateExample: View {
  @State var value = screenshotDate

  var body: some View {
    Form {
      DatePicker("Date", selection: $value, displayedComponents: [.date])
    }
  }
}

struct SimpleTimeExample: View {
  @State var value = screenshotDate

  var body: some View {
    Form {
      DatePicker("Time", selection: $value, displayedComponents: [.hourAndMinute])
    }
  }
}

struct SimpleOptionalDateAndTimeExample: View {
  @State var value: Date?

  var body: some View {
    Form {
      DatePicker("Date & Time", selection: $value)
    }
  }
}

struct SimpleOptionalDateExample: View {
  @State var value: Date?

  var body: some View {
    Form {
      DatePicker("Date", selection: $value, displayedComponents: [.date])
    }
  }
}

struct SimpleOptionalTimeExample: View {
  @State var value: Date?

  var body: some View {
    Form {
      DatePicker("Time", selection: $value, displayedComponents: [.hourAndMinute])
    }
  }
}

struct SimpleDateInputViewExamples: View {
  @State var value = screenshotDate
  
  var body: some View {
    DateInputView(selection: $value)
      .accessibility(addTraits: .isButton)
      .accessibilityIdentifier("DateInputView")
  }
}

struct SimpleTimeInputViewExamples: View {
  @State var value = screenshotDate
  
  var body: some View {
    Group {
      TimeInputView(selection: $value)
        .timeInputViewTwentyFourHour(false)

      TimeInputView(selection: $value)
        .timeInputViewTwentyFourHour()

      TimeInputView(selection: $value)
        .timeInputViewTwentyFourHour()
        .timeInputViewTwentyFourHourIndicator(.hidden)
    }
    .accessibility(addTraits: .isButton)
    .accessibilityIdentifier("TimeInputView")
    .edgesIgnoringSafeArea(.bottom)
    .padding(-10)
  }
}

struct DateAndTimeExamples: View {
  @State var value = screenshotDate
  
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
  @State var value = screenshotDate
  
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
  @State var value = screenshotDate
  
  var body: some View {
    Form {
      DatePicker("Time", selection: $value, displayedComponents: [.hourAndMinute])
      
      DatePicker("Time (24h)", selection: $value, displayedComponents: [.hourAndMinute])
        .timeInputViewTwentyFourHour()
    }
  }
}

struct DateInputViewExamples: View {
  @State var value = screenshotDate
  
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
  @State var value = screenshotDate
  
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
        .navigationTitle(formatted24HourTimeSelection)
        .timeInputViewTwentyFourHour()
      
      TimeInputView(selection: $value)
        .navigationTitle(formatted24HourTimeSelection)
        .timeInputViewTwentyFourHour()
        .timeInputViewTwentyFourHourIndicator(.hidden)

      TimeInputView(selection: $value)
        .navigationTitle(formattedTimeSelection)
        .timeInputViewMonospacedDigit()
      
      TimeInputView(selection: $value)
        .navigationTitle(formatted24HourTimeSelection)
        .environment(\.locale, Locale(identifier: "da"))

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
  @State var value = screenshotDate
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

struct SystemTimeInputView: View {
  @State var coordinator: Coordinator!
  @State var timeInputView: AnyObject!
  @Environment(\.dismiss) var dismiss

  var body: some View {
    VStack {}
      .toolbar {
        ToolbarItem(placement: .confirmationAction) {
          Button("", action: {})
            .accessibilityHidden(true)
        }
      }
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

        timeInputView = PUICTimeInputView.perform(Selector(String(["n", "e", "w"]))).takeRetainedValue()

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

import AuthenticationServices

struct WebKitDatePicker: View {
  var body: some View {
    Button("WebKit Date Picker") {
      let url = URL(string: "https://yari-demos.prod.mdn.mozit.cloud/en-US/docs/Web/HTML/Element/input/date/_sample_.value.html")!
      let session = ASWebAuthenticationSession(url: url, callbackURLScheme: nil) { _, _ in }
      session.prefersEphemeralWebBrowserSession = true
      session.start()
    }
  }
}
