import SwiftUI
import Network

public extension IPv6Address {
  var absoluteString: String {
    debugDescription
      .replacingOccurrences(of: "::", with: String(repeating: ":0000:", count: 1))
  }
}

public struct IPv6AddressPickerView: View {
  let address = IPv6Address("2001:0db8:85a3:0000:0000:8a2e:0370:7334")!
  @State private var focusedComponent = 0
  
  public var body: some View {
    VStack {
      Spacer()
      
//      Text(address.debugDescription)
//      Text(address.debugDescription.replacingOccurrences(of: "::", with: ":0000:"))
      Text(String(describing: address.absoluteString.components(separatedBy: ":")))
        .lineLimit(4)
      
      LazyVGrid(columns: Array.init(repeating: GridItem.init(.flexible(), spacing: -31), count: 4 + 3)) {
        ForEach(0..<8) { i in
          if i % 4 > 0 {
            Text(":")
          }
          
//          Button(String(describing: address).components(separatedBy: ":")[i], action: { focusedComponent = i })
//          Button(address.absoluteString.components(separatedBy: ":")[i], action: { focusedComponent = i })
          Button("2000", action: { focusedComponent = i })
            .buttonStyle(.timePickerComponent(isFocused: focusedComponent == i, width: 39))
            .focusable()
        }
      }
      .font(.footnote)
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

struct IPv6AddressPickerView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      IPv6AddressPickerView()
    }
    .accentColor(.orange)
  }
}
