// Created by manny_lopez on 12/29/24.

import SwiftUI

struct HabitList: View {
  @EnvironmentObject var viewModel: HabitViewModel
  private let today = Date()

  var body: some View {
    NavigationView {
      List(Array(viewModel.habits.values), id: \.id) { habit in
        NavigationLink {
          CalendarView(
            habitID: habit.id,
            currentMonth: viewModel.utils.month(for: today),
            currentYear: viewModel.utils.year(for: today))
        } label: {
          HabitRow(title: habit.name)
        }
      }
      .navigationBarTitle("Habits")
    }
  }
}

#Preview {
  let habits = [
    Habit(name: "Pet my dog", completedDates: [Date()]),
    Habit(name: "Walk around the block", completedDates: [Date()])
  ]
  let viewModel = HabitViewModel(habits: habits)
  HabitList()
    .environmentObject(viewModel)
}
