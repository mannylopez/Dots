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
    if habit.isCompleted(for: date) {
      habit.completedDates.remove(date)
    } else {
      habit.completedDates.insert(date)
    }
  }

  func completedDatesFor(month: Int, year: Int) -> Set<Date> {
    habit.completedDates.filter { date in
      utils.month(for: date) == month && utils.year(for: date) == year
    }
  }

}
