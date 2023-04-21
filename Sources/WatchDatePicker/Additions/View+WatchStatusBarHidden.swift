#if os(watchOS)

import SwiftUI

@available(watchOS 8, *)
extension View {
  func watchStatusBar(hidden: Bool) -> some View {
    toolbar {
      ToolbarItem(placement: .confirmationAction) {
        Button("", action: {})
          .accessibilityHidden(true)
      }
    }
  }
}

#endif
