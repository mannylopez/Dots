// Created by manny_lopez on 12/25/24.

import SwiftUI

// MARK: - MonthView

struct MonthView: View {

  // MARK: Lifecycle

  init(
    utils: CalendarUtils,
    month: Int,
    year: Int)
  {
    self.utils = utils
    self.month = month
    self.year = year
    days = utils.daysInMonth(month: month, year: year)
    startOffset = utils.firstDayOfMonth(month: month, year: year)
    dayToday = utils.dayToday()
  }

  // MARK: Internal

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

  // MARK: Private

  private let columns: [GridItem] = Array(repeating: GridItem(.fixed(25)), count: 7)
  private let utils: CalendarUtils
  private let month: Int
  private let year: Int
  private let days: Range<Int>
  private let startOffset: Int
  private let dayToday: Int

}

#Preview {
  let utils = CalendarUtils.shared
  let month = 2
  let year = 2024
  return MonthView(utils: utils, month: month, year: year)
}
