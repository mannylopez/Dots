// Created by manny_lopez on 12/25/24.

import SwiftUI

@main
struct DotsApp: App {
  let month = 12
  let year = 2024
  let utils = CalendarUtils.shared
  var body: some Scene {
    WindowGroup {
      // TODO: Refactor this
      MonthView(
        days: utils.daysInMonth(month: month, year: year),
        startOffset: utils.firstDayOfMonth(month: month, year: year),
        dayToday: utils.dayToday())
    }
  }
}
