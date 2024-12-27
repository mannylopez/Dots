// Created by manny_lopez on 12/25/24.

import SwiftUI

// MARK: - MonthView

struct MonthView: View {
  let columns: [GridItem] = Array(repeating: GridItem(.fixed(25)), count: 7)
  let days: Range<Int>
  let startOffset: Int
  let dayToday: Int

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
          Text("")
            .foregroundStyle(.secondary)
        }
        ForEach(days, id: \.self) { day in
          DateView(date: day, nonZero: true, addBorder: dayToday == day)
        }
      }
    }
  }
}

#Preview {
  let utils = CalendarUtils.shared
  let month = 2
  let year = 2024
  return MonthView(
    days: utils.daysInMonth(month: month, year: year),
    startOffset: utils.firstDayOfMonth(month: month, year: year),
    dayToday: utils.dayToday())
}
