// Created by manny_lopez on 12/31/24.

import SwiftUI
import UIKit

// MARK: - ImmediateKeyboardHelper

struct ImmediateKeyboardHelper: UIViewRepresentable {
  @Binding var isFirstResponder: Bool

  func updateUIView(_ uiView: UITextView, context _: Context) {
    if isFirstResponder {
      uiView.becomeFirstResponder()
    }
  }

  func makeUIView(context _: Context) -> UITextView {
    let textView = UITextView()
    textView.isHidden = true
    return textView
  }
}

// MARK: - ImmediateKeyboardModifier

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
