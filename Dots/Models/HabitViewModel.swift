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
    let calendar = Calendar.current
    if habit.isCompleted(for: date) {
      if let first = habit.completedDates.first(where: { calendar.isDate($0, inSameDayAs: date) }) {
        habit.completedDates.remove(first)
      }
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

  func addHabit(name: String, color: Color) {
    let habit = Habit(name: name, color: color)
    habits[habit.id] = habit
  }

  func updateHabit(habitID: UUID, name: String, color: Color) {
    habits[habitID]?.name = name
    habits[habitID]?.color = color
  }

  func deleteHabit(habitID: UUID) {
    habits.removeValue(forKey: habitID)
  }

  func updateNote(habitID: UUID, dayModel: DayModel) {
    let calendar = Calendar.current
    guard let note = dayModel.note else {
      if let keyToRemove = habits[habitID]?.notes.keys.first(where: { calendar.isDate($0, inSameDayAs: dayModel.date) }) {
        habits[habitID]?.notes.removeValue(forKey: keyToRemove)
      }
      return
    }
    if let keyToRemove = habits[habitID]?.notes.keys.first(where: { calendar.isDate($0, inSameDayAs: dayModel.date) }) {
      habits[habitID]?.notes.removeValue(forKey: keyToRemove)
    }
    habits[habitID]?.notes[dayModel.date] = note
  }

}
