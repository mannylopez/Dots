// Created by manny_lopez on 12/29/24.

import SwiftUI

struct HabitList: View {

  // MARK: Internal

  @EnvironmentObject var viewModel: HabitViewModel

  var body: some View {
    NavigationView {
      List(viewModel.habitList, id: \.id) { habit in
        NavigationLink {
          CalendarView(
            habitID: habit.id,
            currentMonth: currentMonth,
            currentYear: currentYear)
        } label: {
          HabitRow(
            title: habit.name,
            habitID: habit.id,
            month: currentMonth,
            year: currentYear)
        }
      }
      .navigationBarTitle("Goals")

      VStack {
        Spacer()
        addHabitButton()
      }
    }
    .sheet(isPresented: $showingAddHabit) {
      AddHabitSheet(isPresented: $showingAddHabit)
        .presentationDetents([.fraction(0.25)])
    }
  }

  // MARK: Private

  @State private var showingAddHabit = false

  private let today = Date()

  private var currentMonth: Int {
    viewModel.utils.month(for: today)
  }

  private var currentYear: Int {
    viewModel.utils.year(for: today)
  }

  @ViewBuilder
  private func addHabitButton() -> some View {
    Button {
      print("tapped")
      showingAddHabit = true
    } label: {
      Image(systemName: "plus.circle.fill")
        .font(.system(size: 60))
        .foregroundColor(.primary)
    }
  }

}

#Preview {
  let viewModel = HabitViewModel()
  return HabitList()
    .environmentObject(viewModel)
}
