// Created by manny_lopez on 12/26/24.

import SwiftUI

// MARK: - DateView

struct DateView: View {
  let date: Int
  let nonZero: Bool

  var body: some View {
    ZStack {
      if nonZero {
        Circle()
          .foregroundStyle(.green.opacity(0.6))
          .fixedSize()
      }
      Text(date.toArabicNumeral())
    }
  }
}

#Preview {
  DateView(date: 7, nonZero: true)
}

extension Int {
  func toArabicNumeral() -> String {
    let numberFormatter = NumberFormatter()
    numberFormatter.locale = .init(identifier: "ar-EG")
    return numberFormatter.string(from: NSNumber(value: self)) ?? String(self)
  }
}
