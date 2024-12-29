// Created by manny_lopez on 12/25/24.

import SwiftUI

@main
struct DotsApp: App {
  let today = Date()

  // TODO: Refactor this
  @StateObject private var viewModel = HabitViewModel(habit: Habit(name: "Stretch", completedDates: Set<Date>()))

  var body: some Scene {
    WindowGroup {
      // TODO: Refactor this
      CalendarView(
        currentMonth: viewModel.utils.month(for: today),
        currentYear: viewModel.utils.year(for: today))
        .environmentObject(viewModel)
    }
  }
}
