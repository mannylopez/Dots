// Created by manny_lopez on 12/25/24.

import SwiftUI

@main
struct DotsApp: App {
  let month = 12
  let year = 2024

  // TODO: Refactor this
  @StateObject private var viewModel = HabitViewModel(habit: Habit(name: "Stretch", nonZeroDates: Set<Date>()))

  var body: some Scene {
    WindowGroup {
      // TODO: Refactor this
      VStack {
        MonthView(month: month - 1, year: year)
        MonthView(month: month, year: year)
        MonthView(month: month + 1, year: year)
      }
      .environmentObject(viewModel)
    }
  }
}
