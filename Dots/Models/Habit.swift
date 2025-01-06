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
    let calendar = Calendar.current
    return completedDates.contains { calendar.isDate($0, inSameDayAs: date) }
  }

  func note(for date: Date) -> String? {
    let calendar = Calendar.current
    return notes.first(where: { calendar.isDate($0.key, inSameDayAs: date) })?.value
  }
}
