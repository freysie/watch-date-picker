#if os(watchOS)
import SwiftUI

@available(watchOS 8, *)
@available(macOS, unavailable)
@available(iOS, unavailable)
@available(tvOS, unavailable)
extension View {
  func watchStatusBar(hidden: Bool) -> some View {
    if #available(watchOS 9, *) {
      return self.toolbar(hidden ? .hidden : .visible, for: .automatic)
    }
    else {
      return self.toolbar {
        ToolbarItem(placement: .confirmationAction) {
          Button("", action: {})
            .accessibilityHidden(true)
        }
      }
    }
  }
}
#endif
