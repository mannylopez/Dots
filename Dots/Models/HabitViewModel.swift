// Created by manny_lopez on 12/28/24.

import Foundation

// MARK: - HabitViewModel

class HabitViewModel: ObservableObject {

  // MARK: Lifecycle

  init(habit: Habit) {
    self.habit = habit
  }

  // MARK: Internal

  @Published var habit: Habit
  let utils = CalendarUtils.shared

  func toggleHabit(date: Date) {
    if habit.isNonZero(date: date) {
      habit.nonZeroDates.remove(date)
    } else {
      habit.nonZeroDates.insert(date)
    }
  }

  func nonZeroDatesFor(month: Int, year: Int) -> Set<Date> {
    habit.nonZeroDates.filter { date in
      utils.month(for: date) == month && utils.year(for: date) == year
    }
  }

}
