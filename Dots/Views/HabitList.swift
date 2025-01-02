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
            currentMonth: viewModel.utils.month(for: today),
            currentYear: viewModel.utils.year(for: today))
        } label: {
          HabitRow(title: habit.name)
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
