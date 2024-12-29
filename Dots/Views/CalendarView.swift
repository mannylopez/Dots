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

  struct MonthYear: Hashable {
    let month: Int
    let year: Int
  }

  let habitID: UUID
  let currentMonth: Int
  let currentYear: Int

  var body: some View {
    GeometryReader { geometry in
      ScrollView(.vertical) {
        ScrollViewReader { proxy in

          ForEach(years, id: \.self) { year in
            ForEach(months, id: \.self) { month in
              MonthView(habitID: habitID, month: month, year: year)
                .id(MonthYear(month: month, year: year))
                .offset(y: -(geometry.size.height / 8))
            }
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

  private let months = 1..<13
  // TODO: Refactor this. What years to show and how to send them in?
  private let years = [2024, 2025]

}

#Preview {
  let habits = [Habit(name: "Stretch", completedDates: Set(arrayLiteral: Date()))]
  let viewModel = HabitViewModel(habits: habits)
  let today = Date()

  return CalendarView(
    habitID: viewModel.habits.first.unsafelyUnwrapped.key,
    currentMonth: viewModel.utils.month(for: today),
    currentYear: viewModel.utils.year(for: today))
    .environmentObject(viewModel)
}
