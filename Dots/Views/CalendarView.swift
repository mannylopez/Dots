// Created by manny_lopez on 12/28/24.

import SwiftUI

struct CalendarView: View {

  // MARK: Lifecycle

  init(currentMonth: Int, currentYear: Int) {
    self.currentMonth = currentMonth
    self.currentYear = currentYear
  }

  // MARK: Internal

  struct MonthYear: Hashable {
    let month: Int
    let year: Int
  }

  let currentMonth: Int
  let currentYear: Int

  var body: some View {
    GeometryReader { geometry in
      ScrollView(.vertical) {
        ScrollViewReader { proxy in

          ForEach(years, id: \.self) { year in
            ForEach(months, id: \.self) { month in
              MonthView(month: month, year: year)
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
  let habit = Habit(name: "Stretch", completedDates: Set(arrayLiteral: Date()))
  let viewModel = HabitViewModel(habit: habit)
  let today = Date()

  return CalendarView(
    currentMonth: viewModel.utils.month(for: today),
    currentYear: viewModel.utils.year(for: today))
    .environmentObject(viewModel)
}
