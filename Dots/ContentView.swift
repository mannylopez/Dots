// Created by manny_lopez on 12/25/24.

import SwiftUI

// MARK: - ContentView

struct ContentView: View {
//  let columns: [GridItem] = 
  let days = 1...31 // Adjust based on month

  var body: some View {
    DateView(date: 1, nonZero: true)
  }
}

#Preview {
  ContentView()
}

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
//      Text("\(date)")
    }
  }
}

// #Preview {
//  DateView(date: 7)
// }

extension Int {
  func toArabicNumeral() -> String {
    let numberFormatter = NumberFormatter()
    numberFormatter.locale = Locale(identifier: "ar-EG")
    return numberFormatter.string(from: NSNumber(value: self)) ?? String(self)
  }
}
