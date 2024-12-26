// Created by manny_lopez on 12/25/24.

import SwiftUI

// MARK: - CalendarView

struct CalendarView: View {
  let columns: [GridItem] = Array(repeating: GridItem(.fixed(25)), count: 7)
  let days = 1...31
  let startOffset = 5

  var body: some View {
    VStack {
      LazyVGrid(columns: columns) {
        ForEach(["Su", "M", "T", "W", "Th", "F", "Sa"], id: \.self) { day in
          Text(day)
            .font(.caption)
            .foregroundStyle(.secondary)
        }
      }

      LazyVGrid(columns: columns) {
        ForEach(0..<startOffset, id: \.self) { _ in
          Text("·")
        }
        ForEach(days, id: \.self) { day in
          DateView(date: day, nonZero: true)
        }
      }
    }
  }
}

#Preview {
  CalendarView()
}

extension Int {
  func toArabicNumeral() -> String {
    let numberFormatter = NumberFormatter()
    numberFormatter.locale = Locale(identifier: "ar-EG")
    return numberFormatter.string(from: NSNumber(value: self)) ?? String(self)
  }
}
