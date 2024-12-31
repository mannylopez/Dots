// Created by manny_lopez on 12/31/24.

import SwiftUI

struct ImmediateKeyboardModifier: ViewModifier {
  @State private var isFirstResponder = false
  func body(content: Content) -> some View {
    content
      .background(ImmediateKeyboardHelper(isFirstResponder: $isFirstResponder))
      .onAppear {
        isFirstResponder = true
      }
  }
}

extension View {
  func showKeyboardImmediately() -> some View {
    modifier(ImmediateKeyboardModifier())
  }
}
