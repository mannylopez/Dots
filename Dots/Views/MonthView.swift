// Created by manny_lopez on 12/25/24.

import SwiftUI

// MARK: - MonthView

struct MonthView: View {

  // MARK: Lifecycle

  init(
    habitID: UUID,
    month: Int,
    year: Int)
  {
    self.habitID = habitID
    self.month = month
    self.year = year
  }

  // MARK: Internal

  @EnvironmentObject var viewModel: HabitViewModel

  var body: some View {
    Text(monthName + " \(year)")
      .foregroundStyle(.secondary)
      .padding(.top, 20)
    VStack {
      LazyVGrid(columns: columns) {
        ForEach(["Su", "M", "T", "W", "Th", "F", "Sa"], id: \.self) { day in
          Text(day)
            .font(.caption)
            .foregroundStyle(.secondary)
        }
      }

      LazyVGrid(columns: columns) {
        ForEach(0..<startOffset, id: \.self) { _ in
          Text("")
            .foregroundStyle(.secondary)
        }

        ForEach(days, id: \.self) { day in
          let date = createDate(using: day)
          let isCompleted = isCompleted(date: date)
          DateView(
            date: day,
            isCompleted: isCompleted,
            addBorder: isToday(date: date),
            fillColor: fillColor())
            .onTapGesture {
              print("note", String(describing: note(date: date)))
              selectedDayModel = DayModel(
                day: day,
                note: note(date: date),
                date: date)
            }
        }
        .sheet(item: $selectedDayModel) { dayModel in
          VStack {

            DateView(
              date: dayModel.day,
              isCompleted: isCompleted(date: dayModel.date),
              addBorder: isToday(date: dayModel.date),
              fillColor: fillColor(),
              isLarge: true)
            .padding(.top, 16)
            .onTapGesture {
              viewModel.toggleHabit(habitID: habitID, date: dayModel.date)
              if isCompleted(date: dayModel.date) {
                UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
              }
            }

            TextField("Add notes", text: $noteText, axis: .vertical)
              .padding()
              .overlay(content: {
                RoundedRectangle(cornerRadius: 10)
                  .stroke(Color(.label))
              })
              .padding()
              .onAppear {
                noteText = dayModel.note ?? ""
              }
              .onChange(of: noteText) { newValue in
                viewModel.updateNote(
                  habitID: habitID,
                  dayModel: DayModel(
                    day: dayModel.day,
                    note: newValue.isEmpty ? nil : newValue ,
                    date: dayModel.date))
              }
            Spacer()
          }

          .presentationDetents([.medium])
        }
      }
    }
  }



  // MARK: Private
  @State var noteText: String = ""
  @State private var showDayModal = false
  @State private var selectedDayModel: DayModel? = nil
  @State private var selectedDate: Date? = nil

  private let columns: [GridItem] = Array(repeating: GridItem(.fixed(25)), count: 7)
  private let habitID: UUID
  private let month: Int
  private let year: Int

  private var days: Range<Int> {
    viewModel.utils.daysInMonth(month: month, year: year)
  }

  private var startOffset: Int {
    viewModel.utils.firstDayOfMonth(month: month, year: year)
  }

  private var dayToday: Int {
    viewModel.utils.dayToday()
  }

  private var monthName: String {
    viewModel.utils.monthName(month: month)
  }

  private func createDate(using day: Int) -> Date {
    viewModel.utils.createDate(year: year, month: month, day: day)
  }

  private func isCompleted(date: Date) -> Bool {
    guard let habit = viewModel.habits[habitID] else { return false }
    return habit.isCompleted(for: date)
  }

  private func note(date: Date) -> String? {
    guard let habit = viewModel.habits[habitID] else { return nil }
    return habit.note(for: date)
  }

  private func habitItem() -> Habit? {
    guard let habit = viewModel.habits[habitID] else { return nil }
    return habit
  }

  private func isToday(date: Date) -> Bool {
    viewModel.utils.isToday(date: date)
  }

  private func fillColor() -> Color {
    guard let habit = viewModel.habits[habitID] else { return .green }
    return habit.color
  }

}

#Preview {
  let viewModel = HabitViewModel()
  let firstHabit = viewModel.habits.first.unsafelyUnwrapped
  let today = Date()
  let month = viewModel.utils.month(for: today)
  let year = viewModel.utils.year(for: today)

  return MonthView(
    habitID: firstHabit.key,
    month: month,
    year: year)
    .environmentObject(viewModel)
}

// MARK: - DaySheet

struct DaySheet: View {
  @Binding var isPresented: Bool
  let name: String

  var body: some View {
    Text("Info about individual day")
    Button("Close") {
      isPresented = false
    }
  }
}

struct DayModel: Identifiable {
  let id = UUID()
  let day: Int
  let note: String?
  let date: Date
}
