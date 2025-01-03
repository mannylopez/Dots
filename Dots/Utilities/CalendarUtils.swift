// Created by manny_lopez on 12/26/24.

import Foundation

final class CalendarUtils {

  // MARK: Lifecycle

  init(
    calendar: Calendar = CalendarConfig.calendar,
    dateFormatter: DateFormatter = CalendarConfig.dateFormatter)
  {
    self.calendar = calendar
    self.dateFormatter = dateFormatter
  }

  // MARK: Internal

  static let shared = CalendarUtils()

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
    calendar.component(.day, from: Date())
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

  func month(for date: Date) -> Int {
    calendar.component(.month, from: date)
  }

  func year(for date: Date) -> Int {
    calendar.component(.year, from: date)
  }

  func isToday(date: Date) -> Bool {
    calendar.isDateInToday(date)
  }

  func createDate(year: Int, month: Int, day: Int) -> Date {
    var components = DateComponents()
    components.year = year
    components.month = month
    components.day = day
    guard let date = calendar.date(from: components) else {
      // TODO: Refactor this
      fatalError()
    }
    return date
  }

  // MARK: Private

  private let calendar: Calendar
  private let dateFormatter: DateFormatter

}
