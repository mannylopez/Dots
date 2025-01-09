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

  /// Returns a sorted list of habits by creation date (newest first)
  var habitList: [Habit] {
    var localHabits = Array(habits.values)
    localHabits.sort { $0.creationDate > $1.creationDate }
    return localHabits
  }

  /// Toggles the completion status of a habit for a specific date.
  ///
  /// - Parameters:
  ///   - habitID: The unique identifier of the habit to toggle
  ///   - date: The date for which to toggle the habit's completion status
  ///
  /// - Important: The date is normalized to the start of day to ensure consistent storage and retrieval
  func toggleHabit(habitID: UUID, date: Date) {
    guard var habit = habits[habitID] else { return }

    let normalizedDate = utils.startOfDay(for: date)

    if let completedDate = habit.completedDates.first(where: { utils.isDate($0, inSameDayAs: normalizedDate) }) {
      habit.completedDates.remove(completedDate)
    } else {
      habit.completedDates.insert(normalizedDate)
    }
    habits[habitID] = habit
  }

  /// Returns all completed dates for a specific habit within a given month and year
  ///
  /// This function filters a habit's completed dates to return only those that fall within
  /// the specified month and year. If the habit is not found, returns an empty set.
  ///
  /// ```swift
  /// let habitID = UUID()
  /// let dates = viewModel.completedDatesFor(habitID: habitID, month: 1, year: 2025)
  /// // Returns all completed dates in January 2025 for the specified habit
  /// ```
  ///
  /// - Parameters:
  ///   - habitID: The unique identifier of the habit to query
  ///   - month: The month to filter by (1-12)
  ///   - year: The year to filter by
  /// - Returns: A set of dates representing completed entries for the specified month and year.
  ///           Returns an empty set if the habit is not found or if no completions exist for the specified period.
  func completedDatesFor(habitID: UUID, month: Int, year: Int) -> Set<Date> {
    guard let habit = habits[habitID] else { return [] }
    return habit.completedDates.filter { date in
      utils.month(for: date) == month && utils.year(for: date) == year
    }
  }

  /// Creates and adds a new habit to the habit collection
  ///
  /// - Parameters:
  ///   - name: The name of the habit to create
  ///   - color: The color associated with the habit for visual identification
  func addHabit(name: String, color: Color) {
    let habit = Habit(name: name, color: color)
    habits[habit.id] = habit
  }

  /// Updates an existing habit's name and color
  ///
  /// - Parameters:
  ///   - habitID: The unique identifier of the habit to update
  ///   - name: The new name for the habit
  ///   - color: The new color for the habit
  func updateHabit(habitID: UUID, name: String, color: Color) {
    guard var habit = habits[habitID] else { return }
    habit.name = name
    habit.color = color
    habits[habitID] = habit
  }

  /// Removes a habit from the habit collection
  ///
  /// - Parameter habitID: The unique identifier of the habit to delete
  ///
  /// - Note: This operation is permanent and cannot be undone. If the specified doesn't exist, no action is taken.
  func deleteHabit(habitID: UUID) {
    habits.removeValue(forKey: habitID)
  }

  /// Updates or removes a note for a specific habit on a given date.
  ///
  /// This function manages notes associated with habits by:
  /// - Removing existing notes for the same day if present
  /// - Adding a new note if provided and non-empty
  ///
  /// - Parameters:
  ///   - habitID: The unique identifier of the habit to update
  ///   - date: The date for which the note should be added or updated
  ///   - note: The note text to associate with the habit. If empty, any existing note for that date will be removed
  ///
  /// - Important: The date is normalized to the start of the day to ensure consistent storage and retrieval
  func updateNote(habitID: UUID, date: Date, note: String?) {
    guard var habit = habits[habitID] else { return }

    let normalizedDate = utils.startOfDay(for: date)

    if let entryToRemove = habit.notes.keys.first(where: { utils.isDate($0, inSameDayAs: normalizedDate) }) {
      habit.notes.removeValue(forKey: entryToRemove)
    }

    if let note, !note.isEmpty {
      habit.notes[normalizedDate] = note
    }

    habits[habitID] = habit
  }
}
