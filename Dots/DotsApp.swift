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
      MonthView(utils: utils, month: 11, year: year)
      MonthView(utils: utils, month: month, year: year)
      MonthView(utils: utils, month: 1, year: year + 1)
    }
  }
}
