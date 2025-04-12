// Created by manny_lopez on 12/26/24.

import Foundation

enum CalendarConfig {
  static let calendar: Calendar = {
    var calendar = Calendar(identifier: .gregorian)
    calendar.locale = .current
    calendar.timeZone = .current
    // Ensure first weekday is Sunday (1)
    calendar.firstWeekday = 1
    return calendar
  }()

  static let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.calendar = calendar
    formatter.locale = .current
    formatter.setLocalizedDateFormatFromTemplate("MMMM")
    return formatter
  }()
}
