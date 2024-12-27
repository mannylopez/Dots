// Created by manny_lopez on 12/26/24.

import Foundation

struct CalendarConfig {
  static let calendar: Calendar = {
    var calendar = Calendar.current
    calendar.locale = .current
    calendar.timeZone = .current
    return calendar
  }()
}
