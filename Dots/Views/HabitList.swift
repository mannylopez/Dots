// Created by manny_lopez on 12/29/24.

import SwiftUI

struct HabitList: View {

  // MARK: Internal

  @EnvironmentObject var viewModel: HabitViewModel

  var body: some View {
    NavigationStack(path: $navigationPath) {
      ZStack {
        ScrollView {
          LazyVStack(spacing: 12) {
            ForEach(viewModel.habitList) { habit in
              HabitRow(title: habit.name, habitID: habit.id)
                .onTapGesture {
                  navigationPath.append(habit)
                }
            }
          }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
          ToolbarItem(placement: .principal) {
            HStack {
              Text("Goals")
                .font(.title2)
            }
          }
        }

        .navigationDestination(for: Habit.self) { habit in
          CalendarView(
            habitID: habit.id,
            currentMonth: viewModel.utils.month(for: today),
            currentYear: viewModel.utils.year(for: today))
        }

        VStack {
          Spacer()
          addHabitButton()
        }
      }
      .sheet(isPresented: $showingAddHabit) {
        AddHabitSheet(isPresented: $showingAddHabit)
          .presentationDetents([.fraction(0.25)])
      }
      .background(.gray.opacity(0.1))
    }
  }

  // MARK: Private

  @State private var navigationPath = NavigationPath()

  @State private var showingAddHabit = false

  private let today = Date()

  @ViewBuilder
  private func addHabitButton() -> some View {
    Button {
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
