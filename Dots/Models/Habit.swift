// Created by manny_lopez on 12/27/24.

import Foundation

// MARK: - Habit

struct Habit {
  let name: String
  var completedDates: Set<Date>

  func isCompleted(for date: Date) -> Bool {
    let calendar = Calendar.current
    return completedDates.contains { calendar.isDate($0, inSameDayAs: date) }
  }
}
