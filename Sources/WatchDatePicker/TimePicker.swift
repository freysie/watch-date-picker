import SwiftUI

@available(watchOS 8, *)
@available(macOS, unavailable)
@available(iOS, unavailable)
@available(tvOS, unavailable)
public struct TimePicker: View {
  @State private var pickerViewIsPresented = true
  
  public init() {}
  
  public var body: some View {
    Button(action: { pickerViewIsPresented = true }) {
      VStack(alignment: .leading) {
        Text("Select Time")
        
        Text("13:37")
          .font(.footnote)
          .foregroundStyle(.secondary)
      }
    }
    .fullScreenCover(isPresented: $pickerViewIsPresented) {
      ZStack(alignment: .bottom) {
        TimePickerView(selection: .constant(Date()))
        
        HStack {
          Button(action: { pickerViewIsPresented = false }) {
            Image(systemName: "xmark")
          }
          .buttonStyle(.circular(.gray))
          
          Spacer()

          Button(action: { pickerViewIsPresented = false }) {
            Image(systemName: "checkmark")
          }
          .buttonStyle(.circular(.green))
        }
        .padding(.bottom, -26)
        .padding(.horizontal, 44)
      }
      // .border(.red)
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      // .ignoresSafeArea()
      // .statusBar(hidden: true)
      .toolbar {
        ToolbarItem(placement: .confirmationAction) {
          Button("", action: {}).foregroundColor(.clear)
        }
      }
      .navigationBarHidden(true)
      .edgesIgnoringSafeArea(.all)
      // .padding(.top, -40)
      .padding(.bottom, -40)
      .padding(.horizontal, -32)
      .offset(y: -45)
    }
  }
}
