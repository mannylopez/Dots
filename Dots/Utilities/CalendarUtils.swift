// Created by manny_lopez on 12/26/24.

import Foundation

final class CalendarUtils {
  static let shared = CalendarUtils()

  private let calendar: Calendar
  private let dateFormatter: DateFormatter

  init(
    calendar: Calendar = CalendarConfig.calendar,
    dateFormatter: DateFormatter = CalendarConfig.dateFormatter)
  {
    self.calendar = calendar
    self.dateFormatter = dateFormatter
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

  func monthName(month: Int) -> String {
    var components = DateComponents()
    components.month = month
    components.year = 2024
    guard let date = calendar.date(from: components) else {
      // TODO: Refactor this
      fatalError()
    }
    return dateFormatter.string(from: date)
  }
}
