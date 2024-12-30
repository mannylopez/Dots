// Created by manny_lopez on 12/29/24.

import SwiftUI

struct HabitList: View {

  // MARK: Internal

  @EnvironmentObject var viewModel: HabitViewModel

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
      .toolbar {
        ToolbarItem(placement: .bottomBar) {
          Button {
            print("tapped")
          } label: {
            Image(systemName: "plus.circle.fill")
              .font(.system(size: 60))
              .foregroundColor(.black)
          }
          .padding(.bottom, 85)
        }
      }
    }
  }

  // MARK: Private

  private let today = Date()

}

#Preview {
  let viewModel = HabitViewModel()
  return HabitList()
    .environmentObject(viewModel)
}
