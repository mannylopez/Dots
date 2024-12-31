// Created by manny_lopez on 12/31/24.

import SwiftUI
import UIKit

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
