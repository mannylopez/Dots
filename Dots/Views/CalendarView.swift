// Created by manny_lopez on 12/28/24.

import SwiftUI

struct CalendarView: View {

  @EnvironmentObject var viewModel: HabitViewModel

  // MARK: Lifecycle

  init(
    habitID: UUID,
    currentMonth: Int,
    currentYear: Int)
  {
    self.habitID = habitID
    self.currentMonth = currentMonth
    self.currentYear = currentYear

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

  var body: some View {
    ScrollView(.vertical) {
      ScrollViewReader { proxy in
        addMonthButton(direction: .past)
        monthsGrid(proxy: proxy)
        addMonthButton(direction: .future)
      }
    }
    .navigationTitle(name)
    .navigationBarTitleDisplayMode(.inline)
    .clipped()
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

  private var name: String  {
    viewModel.habits[habitID]?.name ?? ""
  }

  @State private var monthYears: [MonthYear]

  private let habitID: UUID
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
        habitID: habitID,
        month: monthYear.month,
        year: monthYear.year)
        .id(monthYear)
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
  let viewModel = HabitViewModel()
  let today = Date()
  return CalendarView(
    habitID: viewModel.habits.first.unsafelyUnwrapped.key,
    currentMonth: viewModel.utils.month(for: today),
    currentYear: viewModel.utils.year(for: today))
    .environmentObject(viewModel)
}
