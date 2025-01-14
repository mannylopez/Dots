// Created by manny_lopez on 12/28/24.

import CoreData
import SwiftUI

// MARK: - HabitViewModel

class HabitViewModel: ObservableObject {

  // MARK: Lifecycle

  init(context: NSManagedObjectContext, debugMode: Bool = false) {
    viewContext = context

    if debugMode {
      let habits = SampleHabitsHelper.generate()
      self.habits = Dictionary(uniqueKeysWithValues: habits.map { ($0.id, $0) })
    } else {
      habits = [UUID(): Habit(name: "one", color: .green)]
      fetchHabits()
    }
  }

  // MARK: Internal

  @Published var habits: [UUID: Habit]
  @Published var isWesternNumeral: Bool = true

  let utils = CalendarUtils.shared

  /// Returns a sorted list of habits by creation date (newest first)
  var habitList: [Habit] {
    var localHabits = Array(habits.values)
    localHabits.sort { $0.creationDate > $1.creationDate }
    return localHabits
  }

  func isCompleted(date: Date, habitID: UUID) -> Bool {
    guard let habit = habits[habitID] else { return false }
    return habit.completedDates.contains { utils.isDate($0, inSameDayAs: date) }
  }

  func note(for date: Date, habitID: UUID) -> String? {
    guard let habit = habits[habitID] else { return nil }
    let normalizedDate = utils.startOfDay(for: date)
    return habit.notes.first(where: { utils.isDate($0.key, inSameDayAs: normalizedDate) })?.value
  }

  // MARK: Private

  private let viewContext: NSManagedObjectContext

}

// MARK: - HabitViewModel + CRUD (Create, Read, Update, Delete) operations

extension HabitViewModel {
  /// Creates and adds a new habit to the habit collection
  ///
  /// - Parameters:
  ///   - name: The name of the habit to create
  ///   - color: The color associated with the habit for visual identification
  func addHabit(name: String, color: Color) {
    let habit = Habit(name: name, color: color)
    addHabit(habit: habit)
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
    updateHabit(habit: habit)
  }

  /// Removes a habit from the habit collection
  ///
  /// - Parameter habitID: The unique identifier of the habit to delete
  ///
  /// - Note: This operation is permanent and cannot be undone. If the specified doesn't exist, no action is taken.
  func deleteHabit(habitID: UUID) {
    guard let habit = habits[habitID] else { return }
    deleteHabit(habit: habit)
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

    updateHabit(habit: habit)
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

    updateHabit(habit: habit)
  }
}

// MARK: - HabitViewModel + Core Data operations

extension HabitViewModel {

  private func fetchHabits() {
    let request = HabitEntity.fetchRequest()

    do {
      let results = try viewContext.fetch(request)
      habits = Dictionary(uniqueKeysWithValues: results.compactMap { entity in
        guard
          let id = entity.id,
          let name = entity.name,
          let colorHex = entity.colorHex
        else { fatalError() }

        let completedDates = CoreDataTransformer.decode(entity.completedDates) as Set<Date>? ?? []
        let notes = CoreDataTransformer.decode(entity.notes) as [Date: String]? ?? [:]

        let habit = Habit(
          id: id,
          name: name,
          color: Color(hex: colorHex),
          completedDates: completedDates,
          notes: notes)
        return (habit.id, habit)
      })
    } catch {
      fatalError("Error fetching habits: \(error)")
    }
  }

  private func updateHabit(habit: Habit) {
    let request = HabitEntity.fetchRequest()
    request.predicate = NSPredicate(format: "id == %@", habit.id as CVarArg)
    do {
      let results = try viewContext.fetch(request)
      if let entity = results.first {
        entity.name = habit.name
        entity.colorHex = habit.color.toHex()
        entity.completedDates = CoreDataTransformer.encode(habit.completedDates)
        entity.notes = CoreDataTransformer.encode(habit.notes)
        try viewContext.save()
        fetchHabits()
      }
    } catch {
      fatalError("Error updating habit: \(error)")
    }
  }

  private func deleteHabit(habit: Habit) {
    let request = HabitEntity.fetchRequest()
    request.predicate = NSPredicate(format: "id == %@", habit.id as CVarArg)

    do {
      let results = try viewContext.fetch(request)
      if let entity = results.first {
        viewContext.delete(entity)
        try viewContext.save()
        fetchHabits()
      }
    } catch {
      fatalError("Error deleting habit: \(error)")
    }
  }

  private func addHabit(habit: Habit) {
    let habitEntity = HabitEntity(context: viewContext)
    habitEntity.id = UUID()
    habitEntity.name = habit.name
    habitEntity.colorHex = habit.color.toHex()
    habitEntity.creationDate = Date()

    do {
      try viewContext.save()
      fetchHabits()
    } catch {
      fatalError("Error adding habit: \(error)")
    }
  }

  private func saveHabit(_ habit: Habit) {
    let entity = HabitEntity(context: viewContext)
    entity.id = habit.id
    entity.name = habit.name
    entity.colorHex = habit.color.toHex()
    entity.creationDate = habit.creationDate
    entity.completedDates = CoreDataTransformer.encode(habit.completedDates)
    entity.notes = CoreDataTransformer.encode(habit.notes)

    do {
      try viewContext.save()
      fetchHabits()
    } catch {
      fatalError("Error saving habit: \(error)")
    }
  }
}

// MARK: - HabitViewModel + SwiftUI Preview

extension HabitViewModel {
  static var preview: HabitViewModel {
    let container = NSPersistentContainer(name: "HabitTracker")
    container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")

    container.loadPersistentStores { _, error in
      if let error {
        fatalError("Error: \(error.localizedDescription)")
      }
    }

    return HabitViewModel(context: container.viewContext, debugMode: true)
  }
}
