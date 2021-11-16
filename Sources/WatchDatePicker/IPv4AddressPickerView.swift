import SwiftUI
import Network

@available(watchOS 8, *)
public struct _IPv4AddressPickerView: View {
  let address = IPv4Address("255.254.253.252")!
  @State private var focusedComponent = 0
  
  public var body: some View {
    VStack {
      Spacer()
      
      HStack(spacing: 2) {
        ForEach(0..<4) { i in
          if i > 0 {
            Text(".")
          }
          
          Button(String(describing: address).components(separatedBy: ".")[i], action: { focusedComponent = i })
            .buttonStyle(.timePickerComponent(isFocused: focusedComponent == i, width: 37))
            .focusable()
        }
      }
      .font(.body)
      .padding(.bottom, 30)
      
      Button("Set", action: {})
        .buttonStyle(.borderedProminent)
        .foregroundStyle(.background)
        .tint(.green)
        .padding(.horizontal)
      
      Spacer()
    }
  }
}

struct IPv4AddressPickerView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      _IPv4AddressPickerView()
    }
    .accentColor(.orange)
  }
}
