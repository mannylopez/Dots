// Created by manny_lopez on 12/29/24.

import SwiftUI

// MARK: - SampleHabitsHelper

enum SampleHabitsHelper {

  // MARK: Internal

  static func generate() -> [Habit] {
    [
//      createHabit(
//        name: "Morning Stretch",
//        consistency: .high),
      createHabit(
        name: "Meditation",
        consistency: .medium),
//      createHabit(
//        name: "Read 30 mins",
//        consistency: .low),
//      createHabit(
//        name: "Drink Water",
//        consistency: .veryHigh),
//      createHabit(
//        name: "Super long long name for habit - low",
//        consistency: .low),
//      createHabit(
//        name: "Walk the dog - complete",
//        consistency: .complete),
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

  private static let sampleNotes = [
    "Felt great today! 💪",
    "Need to improve tomorrow 📝",
    "Making progress slowly but surely 🌱",
    "Skipped yesterday, but back on track today 🎯",
    "Best session so far! 🌟",
    "Struggled a bit, but got it done ✅",
    "Really enjoying this habit 😊",
    "Need more consistency 🔄",
    "Perfect form today 👌",
    "Getting easier each day 📈"
  ]

  private static func createHabit(
    name: String,
    consistency: Consistency,
    startMonth: Int = 9)
    -> Habit
  {
    let calendar = Calendar.current
    var dates = Set<Date>()
    var notes: [Date: String] = [:]

    // Create date components
    var components = DateComponents()
    components.year = 2024

    // Generate dates from start month until now
    for month in startMonth...13 {
      components.month = month

      // For each day in the month
      for day in 1...28 {
        components.day = day

        // Add random time components
        components.hour = Int.random(in: 0...23)
        components.minute = Int.random(in: 0...59)
        components.second = Int.random(in: 0...59)

        // Randomly complete based on consistency
        if
          Double.random(in: 0...1) < consistency.completionRate,
          let date = calendar.date(from: components)
        {
          dates.insert(date)
          notes[date] = sampleNotes.randomElement()
        }
      }
    }

    return Habit(name: name, color: Color.green.opacity(0.4), completedDates: dates, notes: notes)
  }
}
