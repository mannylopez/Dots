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
    GeometryReader { geometry in
      ScrollView(.vertical) {
        ScrollViewReader { proxy in
          ForEach(monthYears, id: \.self) { monthYear in
            MonthView(
              habitID: habitID,
              month: monthYear.month,
              year: monthYear.year)
              .id(monthYear)
              .offset(y: -(geometry.size.height / 8))
          }
          .onAppear {
            proxy.scrollTo(MonthYear(month: currentMonth, year: currentYear), anchor: .center)
          }
        }
      }
      .clipped()
    }
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
