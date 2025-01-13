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

  /// Returns an array of day numbers for the week containing the specified date.
  ///
  /// This function calculates all seven days of the week that contains the input date.
  /// For example, if the input date is January 15, 2025 (Wednesday), and the calendar
  /// week starts on Sunday, the function returns [12, 13, 14, 15, 16, 17, 18].
  ///
  /// ```swift
  /// let utils = CalendarUtils.shared
  /// let date = utils.createDate(year: 2025, month: 1, day: 15)
  /// let days = utils.daysInCurrentWeek(from: date)
  /// print(days) // [12, 13, 14, 15, 16, 17, 18]
  /// ```
  ///
  /// - Parameter date: The reference date used to determine the week.
  /// - Returns: An array of integers representing the days of the month for the entire week.
  ///           Returns an empty array if the week calculation fails.
  /// - Note: The returned array always contains exactly 7 numbers, representing Sunday through Saturday
  ///         by default, based on the calendar's configuration.
  func daysInCurrentWeek(from date: Date) -> [Int] {
    guard
      let startOfWeek = calendar.date(
        from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date))
    else {
      return []
    }

    var days: [Int] = []

    // Add 7 days starting from the start of week
    for dayOffset in 0...6 {
      guard
        let date = calendar.date(
          byAdding: .day,
          value: dayOffset,
          to: startOfWeek)
      else { continue }

      let dayComponent = calendar.component(.day, from: date)
      days.append(dayComponent)
    }

    return days
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

  func isDate(_ date1: Date, inSameDayAs date2: Date) -> Bool {
    let start1 = startOfDay(for: date1)
    let start2 = startOfDay(for: date2)
    return calendar.isDate(start1, inSameDayAs: start2)
  }

  func startOfDay(for date: Date) -> Date {
    calendar.startOfDay(for: date)
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

  /// Creates a date set to the start of the specified day.
  ///
  /// - Parameters:
  ///   - year: The year component
  ///   - month: The month component (1-12)
  ///   - day: The day component
  /// - Returns: A date object set to 00:00:00 of the specified day
  /// - Important: Time components are automatically set to the start of day (00:00:00)
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
