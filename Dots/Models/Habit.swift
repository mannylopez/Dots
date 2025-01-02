// Created by manny_lopez on 12/27/24.

import Foundation

// MARK: - Habit

struct Habit: Identifiable, Hashable {

  // MARK: Lifecycle

  init(
    id: UUID = UUID(),
    name: String,
    completedDates: Set<Date> = [])
  {
    self.id = id
    self.name = name
    self.completedDates = completedDates
    creationDate = Date()
  }

  // MARK: Internal

  let id: UUID
  let name: String
  var completedDates: Set<Date>
  let creationDate: Date

  func isCompleted(for date: Date) -> Bool {
    let calendar = Calendar.current
    return completedDates.contains { calendar.isDate($0, inSameDayAs: date) }
  }
}
