// Created by manny_lopez on 12/26/24.

import Foundation

final class CalendarUtils {
  static let shared = CalendarUtils()

  private let calendar: Calendar

  init(calendar: Calendar = CalendarConfig.calendar) {
    self.calendar = calendar
  }

  // TODO: Refactor this
  func daysInMonth(month: Int, year: Int) -> Range<Int> {
    let dateComponents = DateComponents(year: year, month: month)
    guard let date = calendar.date(from: dateComponents) else {
      // TODO: Refactor this
      fatalError()
    }
    guard let range = calendar.range(of: .day, in: .month, for: date) else {
      // TODO: Refactor this
      fatalError()
    }
    return range
  }

  // TODO: Refactor this
  func firstDayOfMonth(month: Int = 2, year: Int = 2024) -> Int {
    let dateComponents = DateComponents(year: year, month: month, day: 1)
    guard let date = calendar.date(from: dateComponents) else {
      // TODO: Refactor this
      fatalError()
    }
    return calendar.component(.weekday, from: date) - 1
  }

  func dayToday() -> Int {
    return calendar.component(.day, from: Date())
  }

  func monthToday() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.calendar = calendar
    dateFormatter.setLocalizedDateFormatFromTemplate("MMMM")
    return dateFormatter.string(from: Date())
  }
}
