// Created by manny_lopez on 12/28/24.

import SwiftUI

// MARK: - HabitViewModel

class HabitViewModel: ObservableObject {

  // MARK: Lifecycle

  init(habits: [Habit] = SampleHabitsHelper.generate()) {
    self.habits = Dictionary(uniqueKeysWithValues: habits.map { ($0.id, $0) })
  }

  // MARK: Internal

  @Published var habits: [UUID: Habit]

  let utils = CalendarUtils.shared

  var habitList: [Habit] {
    var localHabits = Array(habits.values)
    localHabits.sort { $0.creationDate > $1.creationDate }
    return localHabits
  }

  func toggleHabit(habitID: UUID, date: Date) {
    // TODO: Refactor this (fails silently)
    guard var habit = habits[habitID] else { return }
    if habit.isCompleted(for: date) {
      habit.completedDates.remove(date)
    } else {
      habit.completedDates.insert(date)
    }
    habits[habitID] = habit
  }

  func completedDatesFor(habitID: UUID, month: Int, year: Int) -> Set<Date> {
    // TODO: Refactor this (fails silently)
    guard let habit = habits[habitID] else { return [] }
    return habit.completedDates.filter { date in
      utils.month(for: date) == month && utils.year(for: date) == year
    }
  }

  func addHabit(name: String) {
    let habit = Habit(name: name)
    habits[habit.id] = habit
  }

  func updateHabit(habitID: UUID, name: String, color: Color) {
    habits[habitID]?.name = name
    habits[habitID]?.color = color
  }

  func deleteHabit(habitID: UUID) {
    print("count", habits.count)
    habits.removeValue(forKey: habitID)
    print("count", habits.count)
  }

}
