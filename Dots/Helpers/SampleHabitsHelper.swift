// Created by manny_lopez on 12/29/24.

import Foundation

enum SampleHabitsHelper {
  static func generate() -> [Habit] {
    [
      createHabit(
        name: "Morning Stretch",
        consistency: .high
      ),
      createHabit(
        name: "Meditation",
        consistency: .medium
      ),
      createHabit(
        name: "Read 30 mins",
        consistency: .low
      ),
      createHabit(
        name: "Drink Water",
        consistency: .veryHigh
      ),
      createHabit(
        name: "Evening Walk - low",
        consistency: .low
      ),
      createHabit(
        name: "Walk the dog - complete",
        consistency: .complete
      ),
    ]
  }

  // MARK: Private

  private enum Consistency {
    case low // 30% completion rate
    case medium // 50% completion rate
    case high // 70% completion rate
    case veryHigh // 90% completion rate
    case complete

    var completionRate: Double {
      switch self {
      case .low: 0.3
      case .medium: 0.5
      case .high: 0.7
      case .veryHigh: 0.9
      case .complete: 1
      }
    }
  }

  private static func createHabit(
    name: String,
    consistency: Consistency,
    startMonth: Int = 9)
    -> Habit
  {
    let calendar = Calendar.current
    var dates = Set<Date>()

    // Create date components
    var components = DateComponents()
    components.year = 2024

    // Generate dates from start month until now
    for month in startMonth...13 {
      components.month = month

      // For each day in the month
      for day in 1...28 {
        components.day = day

        // Randomly complete based on consistency
        if
          Double.random(in: 0...1) < consistency.completionRate,
          let date = calendar.date(from: components)
        {
          dates.insert(date)
        }
      }
    }

    return Habit(name: name, completedDates: dates)
  }
}
