// Created by manny_lopez on 12/26/24.

import SwiftUI

// MARK: - DateView

struct DateView: View, Identifiable {
  let id = UUID()
  let date: Int
  let isCompleted: Bool
  let addBorder: Bool
  let fillColor: Color
  var isLarge: Bool = false
  let smallSizeUnit: CGFloat = 25
  let largeSizeUnit: CGFloat = 25

  var body: some View {
    if isLarge {
      large()
    } else {
      small()
    }
  }

  @ViewBuilder
  private func small() -> some View {
    ZStack {
      if isCompleted {
        Circle()
          .foregroundStyle(fillColor)
          .frame(width: 23)
      }
//      Text(date.toArabicNumeral())
      Text("\(date)")

        .frame(width: smallSizeUnit, height: smallSizeUnit)
        .overlay {
          Circle()
            .stroke(addBorder ? Color(.label) : .clear, lineWidth: 2)
        }
    }
  }

  @ViewBuilder
  private func large() -> some View {
    ZStack {
      if isCompleted {
        Circle()
          .foregroundStyle(fillColor)
          .frame(width: 100, height: 100)
      }
//      Text(date.toArabicNumeral())
      Text("\(date)")
        .font(.largeTitle)
        .frame(width: 100, height: 100)
        .overlay {
          Circle()
            .stroke(.gray, lineWidth: 2)
        }
    }
  }
}

#Preview {
  DateView(date: 7, isCompleted: true, addBorder: true, fillColor: .green)
}

extension Int {
  func toArabicNumeral() -> String {
    let numberFormatter = NumberFormatter()
    numberFormatter.locale = .init(identifier: "ar-EG")
    return numberFormatter.string(from: NSNumber(value: self)) ?? String(self)
  }
}
