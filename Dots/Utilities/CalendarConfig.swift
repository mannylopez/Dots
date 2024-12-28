// Created by manny_lopez on 12/26/24.

import Foundation

enum CalendarConfig {
  static let calendar: Calendar = {
    var calendar = Calendar.current
    calendar.locale = .current
    calendar.timeZone = .current
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
