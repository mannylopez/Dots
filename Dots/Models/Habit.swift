// Created by manny_lopez on 12/27/24.

import SwiftUI

// MARK: - Habit

struct Habit: Identifiable, Hashable {

  // MARK: Lifecycle

  init(
    id: UUID = UUID(),
    name: String,
    color: Color,
    completedDates: Set<Date> = [],
    notes: [Date: String] = [:])
  {
    self.id = id
    self.name = name
    self.color = color
    self.completedDates = completedDates
    self.notes = notes
    creationDate = Date()
  }

  // MARK: Internal

  let id: UUID
  var name: String
  var color: Color
  var completedDates: Set<Date>
  let creationDate: Date
  var notes: [Date: String]

  func isCompleted(for date: Date) -> Bool {
    completedDates.contains { utils.isDate($0, inSameDayAs: date) }
  }

  func note(for date: Date) -> String? {
    let normalizedDate = utils.startOfDay(for: date)
    return notes.first(where: { utils.isDate($0.key, inSameDayAs: normalizedDate) })?.value
  }

  // MARK: Private

  private let utils = CalendarUtils.shared

}

// MARK: Equatable

extension Habit: Equatable {
  static func ==(lhs: Habit, rhs: Habit) -> Bool {
    lhs.id == rhs.id &&
      lhs.name == rhs.name &&
      lhs.completedDates == rhs.completedDates &&
      lhs.creationDate == rhs.creationDate &&
      lhs.notes == rhs.notes
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
    hasher.combine(name)
    hasher.combine(completedDates)
    hasher.combine(creationDate)
    hasher.combine(notes)
  }
}
