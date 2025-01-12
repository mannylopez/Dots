// Created by manny_lopez on 12/28/24.

import SwiftUI

struct CalendarView: View {

  // MARK: Lifecycle

  init(
    habit: Habit,
    currentMonth: Int,
    currentYear: Int,
    dismissToRoot: @escaping () -> Void)
  {
    self.habit = habit
    self.currentMonth = currentMonth
    self.currentYear = currentYear
    self.dismissToRoot = dismissToRoot

    // Initialize with the months preceding and following the current month
    let initial = (-3...3).map { offset in
      let (month, year) = CalendarView.calculateMonth(
        fromMonth: currentMonth,
        year: currentYear,
        offset: offset)
      return MonthYear(month: month, year: year)
    }
    _monthYears = State(initialValue: initial)
  }

  // MARK: Internal

  @EnvironmentObject var viewModel: HabitViewModel

  var body: some View {
    ScrollView(.vertical) {
      ScrollViewReader { proxy in
        addMonthButton(direction: .past)
        monthsGrid(proxy: proxy)
        addMonthButton(direction: .future)
      }
      .navigationTitle(habitName())
      .navigationBarTitleDisplayMode(.inline)
    }
    .toolbar {
      ToolbarItem(placement: .confirmationAction) {
        Button {
          showingConfigureHabitSheet = true
        } label: {
          Image(systemName: "gearshape")
        }
      }
    }
    .sheet(isPresented: $showingConfigureHabitSheet) {
      ConfigureHabitSheet(
        isPresented: $showingConfigureHabitSheet,
        habit: habit,
        name: habitName(),
        color: habitColor(),
        dismissToRoot: dismissToRoot)
    }
  }

  // MARK: Private

  private struct MonthYear: Hashable {
    let month: Int
    let year: Int
  }

  private enum TimeDirection {
    case past
    case future
  }

  @State private var monthYears: [MonthYear]
  @State private var showingConfigureHabitSheet = false

  private let dismissToRoot: () -> Void

  private let habit: Habit
  private let currentMonth: Int
  private let currentYear: Int

  /// Helper function to calculate month and year
  private static func calculateMonth(
    fromMonth: Int,
    year: Int,
    offset: Int)
    -> (month: Int, year: Int)
  {
    let totalMonths = fromMonth + offset
    let newMonth = ((totalMonths - 1 + 12) % 12) + 1
    let yearOffset = (totalMonths - 1) / 12
    let newYear = year + (totalMonths <= 0 ? yearOffset - 1 : yearOffset)
    return (newMonth, newYear)
  }

  private func habitName() -> String {
    viewModel.habits[habit.id]?.name ?? habit.name
  }

  private func habitColor() -> Color {
    viewModel.habits[habit.id]?.color ?? .green
  }

  private func addMonth(direction: TimeDirection) {
    guard let referenceMonth = direction == .past ? monthYears.first : monthYears.last else { return }
    let offset = direction == .past ? -1 : 1
    let (month, year) = CalendarView.calculateMonth(fromMonth: referenceMonth.month, year: referenceMonth.year, offset: offset)
    let newMonthYear = MonthYear(month: month, year: year)

    let insertionIndex = direction == .past ? 0 : monthYears.count
    monthYears.insert(newMonthYear, at: insertionIndex)
  }

  private func monthToScrollTo() -> Int {
    currentMonth == 1 ? 12 : currentMonth - 1
  }

  private func yearToScrollTo() -> Int {
    currentMonth == 1 ? currentYear - 1 : currentYear
  }

  // MARK: Views

  @ViewBuilder
  private func monthsGrid(proxy: ScrollViewProxy) -> some View {
    ForEach(monthYears, id: \.self) { monthYear in
      MonthView(
        habitID: habit.id,
        month: monthYear.month,
        year: monthYear.year)
        .id(monthYear)

      Divider()
        .frame(maxWidth: 150)
        .padding(.top, 20)
    }
    .onAppear {
      proxy.scrollTo(
        MonthYear(
          month: monthToScrollTo(),
          year: yearToScrollTo()),
        anchor: .top)
    }
  }

  @ViewBuilder
  private func addMonthButton(direction: TimeDirection) -> some View {
    Button {
      addMonth(direction: direction)
    } label: {
      Text("Load more")
    }
  }

}

#Preview {
  let viewModel = HabitViewModel.preview
  let today = Date()
  CalendarView(
    habit: viewModel.habitList.first!,
    currentMonth: viewModel.utils.month(for: today),
    currentYear: viewModel.utils.year(for: today),
    dismissToRoot: { })
    .environmentObject(viewModel)
}
