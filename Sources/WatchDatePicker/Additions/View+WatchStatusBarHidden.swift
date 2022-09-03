import SwiftUI

@available(watchOS 8, *)
@available(macOS, unavailable)
@available(iOS, unavailable)
@available(tvOS, unavailable)
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
