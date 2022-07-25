import SwiftUI

@main
struct DatePickerExamplesApp: App {
  var body: some Scene {
    WindowGroup {
      NavigationView {
        DatePickerExamples()
      }

//      Text("hi")
//        .ignoresSafeArea(.all, edges: .all)
//        // .ignoresSafeArea()
//        .edgesIgnoringSafeArea(.all)
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .toolbar { ToolbarItem(placement: .confirmationAction) { Button("", action: {}).foregroundColor(.clear) } }
//        .navigationBarHidden(true)
//        .background(.pink)
//        .border(.indigo)
    }
  }
}
