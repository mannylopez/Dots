// Created by manny_lopez on 12/29/24.

import SwiftUI

struct HabitList: View {

  // MARK: Internal

  @EnvironmentObject var viewModel: HabitViewModel

  var body: some View {
    NavigationStack(path: $navigationPath) {
      ZStack {
        ScrollView {
          LazyVStack(spacing: 20) {
            ForEach(viewModel.habitList) { habit in
              HabitRow(
                title: habit.name,
                habitID: habit.id,
                year: currentYear)
                .onTapGesture {
                  navigationPath.append(habit)
                }
            }
          }
          .padding(.bottom, 88)
        }
        .scrollIndicators(.hidden)

        VStack {
          Spacer()
          addHabitButton()
        }
      }
      .navigationTitle("Goals")
      .navigationDestination(for: Habit.self) { habit in
        CalendarView(
          habit: habit,
          currentMonth: currentMonth,
          currentYear: currentYear,
          dismissToRoot: {
            navigationPath = NavigationPath()
          })
      }
    }
    .sheet(isPresented: $showingAddHabit) {
      AddHabitSheet(isPresented: $showingAddHabit)
    }
  }

  // MARK: Private

  @State private var showingAddHabit = false

  @State private var navigationPath = NavigationPath()

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
      showingAddHabit = true
    } label: {
      Image(systemName: "plus.circle.fill")
        .font(.system(size: 60))
        .foregroundStyle(Color(.systemBackground), Color(.label))
    }
    .adaptiveShadow()
  }

}

#Preview {
  let viewModel = HabitViewModel.preview
  return HabitList()
    .environmentObject(viewModel)
}
