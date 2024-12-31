// Created by manny_lopez on 12/31/24.

import UIKit
import SwiftUI

struct ImmediateKeyboardHelper: UIViewRepresentable {
  @Binding var isFirstResponder: Bool

  func updateUIView(_ uiView: UITextView, context: Context) {
    if isFirstResponder {
      uiView.becomeFirstResponder()
    }
  }

  func makeUIView(context: Context) -> UITextView {
    let textView = UITextView()
    textView.isHidden = true
    return textView
  }
}

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
    self.modifier(ImmediateKeyboardModifier())
  }
}
