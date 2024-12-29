// Created by manny_lopez on 12/25/24.

import SwiftUI

// MARK: - MonthView

struct MonthView: View {

  // MARK: Lifecycle

  init(
    habitID: UUID,
    month: Int,
    year: Int)
  {
    self.habitID = habitID
    self.month = month
    self.year = year
  }

  // MARK: Internal

  @EnvironmentObject var viewModel: HabitViewModel

  var body: some View {
    Text(monthName + " \(year)")
      .foregroundStyle(.secondary)
      .padding(.top, 20)
    VStack {
      LazyVGrid(columns: columns) {
        ForEach(["Su", "M", "T", "W", "Th", "F", "Sa"], id: \.self) { day in
          Text(day)
            .font(.caption)
            .foregroundStyle(.secondary)
        }
      }

      LazyVGrid(columns: columns) {
        ForEach(0..<startOffset, id: \.self) { _ in
          Text("")
            .foregroundStyle(.secondary)
        }

        ForEach(days, id: \.self) { day in
          let date = createDate(using: day)
          let isCompleted = isCompleted(date: date)
          DateView(
            date: day,
            isCompleted: isCompleted,
            addBorder: isToday(date: date))
            .onTapGesture {
              viewModel.toggleHabit(habitID: habitID, date: date)
            }
        }
      }
    }
  }

  // MARK: Private

  private let columns: [GridItem] = Array(repeating: GridItem(.fixed(25)), count: 7)
  private let habitID: UUID
  private let month: Int
  private let year: Int

  private var days: Range<Int> {
    viewModel.utils.daysInMonth(month: month, year: year)
  }

  private var startOffset: Int {
    viewModel.utils.firstDayOfMonth(month: month, year: year)
  }

  private var dayToday: Int {
    viewModel.utils.dayToday()
  }

  private var monthName: String {
    viewModel.utils.monthName(month: month)
  }

  private func createDate(using day: Int) -> Date {
    viewModel.utils.createDate(year: year, month: month, day: day)
  }

  private func isCompleted(date: Date) -> Bool {
    guard let habit = viewModel.habits[habitID] else { return false }
    return habit.isCompleted(for: date)
  }

  private func isToday(date: Date) -> Bool {
    viewModel.utils.isToday(date: date)
  }

}

#Preview {
  let month = 12
  let year = 2024
  let habit = [Habit(name: "Stretch", completedDates: Set(arrayLiteral: Date()))]
  let viewModel = HabitViewModel(habits: habit)

  MonthView(
    habitID: viewModel.habits.first.unsafelyUnwrapped.key,
    month: month,
    year: year)
    .environmentObject(viewModel)
}
