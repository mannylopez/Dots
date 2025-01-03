// Created by manny_lopez on 12/26/24.

import SwiftUI

// MARK: - DateView

struct DateView: View {
  let date: Int
  let isCompleted: Bool
  let addBorder: Bool

  var body: some View {
    ZStack {
      if isCompleted {
        Circle()
          .foregroundStyle(.green.opacity(0.4))
          .frame(width: 23)
      }
      Text(date.toArabicNumeral())
//      Text("\(date)")
        .frame(width: 25, height: 25)
        .overlay {
          Circle()
            .stroke(addBorder ? Color(.label) : .clear, lineWidth: 2)
        }
    }
  }
}

#Preview {
  DateView(date: 7, isCompleted: true, addBorder: true)
}

extension Int {
  func toArabicNumeral() -> String {
    let numberFormatter = NumberFormatter()
    numberFormatter.locale = .init(identifier: "ar-EG")
    return numberFormatter.string(from: NSNumber(value: self)) ?? String(self)
  }
}
