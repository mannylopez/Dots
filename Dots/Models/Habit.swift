// Created by manny_lopez on 12/27/24.

import Foundation

// MARK: - Habit

struct Habit {
  let name: String
  var nonZeroDates: Set<Date>

  func isNonZero(date: Date) -> Bool {
    let calendar = Calendar.current
    return nonZeroDates.contains { calendar.isDate($0, inSameDayAs: date) }
  }
}
