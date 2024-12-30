// Created by manny_lopez on 12/28/24.

import SwiftUI

struct CalendarView: View {

  // MARK: Lifecycle

  init(
    habitID: UUID,
    currentMonth: Int,
    currentYear: Int)
  {
    self.habitID = habitID
    self.currentMonth = currentMonth
    self.currentYear = currentYear
  }

  // MARK: Internal

  var body: some View {
    ScrollView(.vertical) {
      ScrollViewReader { proxy in

        ForEach(monthYears, id: \.self) { monthYear in
          MonthView(
            habitID: habitID,
            month: monthYear.month,
            year: monthYear.year)
            .id(monthYear)
        }
        .onAppear {
          proxy.scrollTo(
            MonthYear(
              month: monthToScrollTo(),
              year: yearToScrollTo()),
            anchor: .top)
        }
      }
    }
    .clipped()
  }

  // MARK: Private

  private struct MonthYear: Hashable {
    let month: Int
    let year: Int
  }

  private let habitID: UUID
  private let currentMonth: Int
  private let currentYear: Int

  private let months = 1..<13
  // TODO: Refactor this. What years to show and how to send them in?
  private let years = [2024, 2025]

  private var monthYears: [MonthYear] {
    years.flatMap { year in
      months.map { month in
        MonthYear(month: month, year: year)
      }
    }
  }

  private func monthToScrollTo() -> Int {
    currentMonth == 1 ? 12 : currentMonth - 1
  }

  private func yearToScrollTo() -> Int {
    currentMonth == 1 ? currentYear - 1 : currentYear
  }

}

#Preview {
  let viewModel = HabitViewModel()
  let today = Date()
  return CalendarView(
    habitID: viewModel.habits.first.unsafelyUnwrapped.key,
    currentMonth: viewModel.utils.month(for: today),
    currentYear: viewModel.utils.year(for: today))
    .environmentObject(viewModel)
}
