// Created by manny_lopez on 12/27/24.

import SwiftUI

// MARK: - Habit

struct Habit: Identifiable, Hashable {

  // MARK: Lifecycle

  init(
    id: UUID = UUID(),
    name: String,
    color: Color = .green.opacity(0.3),
    completedDates: Set<Date> = [])
  {
    self.id = id
    self.name = name
    self.color = color
    self.completedDates = completedDates
    creationDate = Date()
  }

  // MARK: Internal

  let id: UUID
  var name: String
  var color: Color
  var completedDates: Set<Date>
  let creationDate: Date

  func isCompleted(for date: Date) -> Bool {
    let calendar = Calendar.current
    return completedDates.contains { calendar.isDate($0, inSameDayAs: date) }
  }
}
