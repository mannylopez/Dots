// Created by manny_lopez on 12/25/24.

import CoreData
import SwiftUI

// MARK: - WeekView

struct WeekView: View {

  // MARK: Lifecycle

  init(
    habitID: UUID,
    year: Int)
  {
    self.habitID = habitID
    self.year = year
  }

  // MARK: Internal

  var body: some View {
    VStack {
      LazyVGrid(columns: columns) {
        ForEach(["Su", "M", "T", "W", "Th", "F", "Sa"], id: \.self) { day in
          Text(day)
            .font(.caption)
            .foregroundStyle(.secondary)
        }
      }

      LazyVGrid(columns: columns) {
        ForEach(weekDays, id: \.self) { weekDay in
          let date = createDate(using: weekDay)
          let isCompleted = viewModel.isCompleted(date: date, habitID: habitID)
          DateView(
            date: weekDay.day,
            isCompleted: isCompleted,
            addBorder: isToday(date: date),
            fillColor: fillColor())
            .onTapGesture {
              viewModel.toggleHabit(habitID: habitID, date: date)
              if !isCompleted {
                UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
              }
            }
            .onLongPressGesture {
              selectedDayModel = DayModel(
                id: habitID,
                day: weekDay.day,
                note: viewModel.note(for: date, habitID: habitID),
                date: date)
            }
        }
      }
    }
    .padding(.top, 20)
    .sheet(item: $selectedDayModel) { dayModel in
      addNoteSheetContent(dayModel: dayModel)
    }
  }

  // MARK: Private

  private struct WeekDay: Hashable {
    let month: Int
    let day: Int
  }

  @State private var noteText = ""
  @State private var showingNoteSheet = false
  @State private var selectedDayModel: DayModel? = nil

  @EnvironmentObject private var viewModel: HabitViewModel

  private let columns: [GridItem] = Array(repeating: GridItem(.fixed(25)), count: 7)
  private let habitID: UUID
  private let year: Int

  private var weekDays: [WeekDay] {
    let date = Date()
    print(viewModel.utils.daysInCurrentWeek(from: date).map {
      WeekDay(month: $0, day: $1)
    })
    return viewModel.utils.daysInCurrentWeek(from: date).map {
      WeekDay(month: $0, day: $1)
    }
  }

  private func createDate(using weekDay: WeekDay) -> Date {
    viewModel.utils.createDate(year: year, month: weekDay.month, day: weekDay.day)
  }

  private func isToday(date: Date) -> Bool {
    viewModel.utils.isToday(date: date)
  }

  private func fillColor() -> Color {
    guard let habit = viewModel.habits[habitID] else { return .green }
    return habit.color
  }

  @ViewBuilder
  private func addNoteSheetContent(dayModel: DayModel) -> some View {
    NavigationStack {
      VStack {
        Text(String(describing: dayModel.date))

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
            viewModel.updateNote(habitID: dayModel.id, date: dayModel.date, note: newValue)
          }
      }
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          Button("Done") {
            selectedDayModel = nil
          }
        }
      }
    }
    .presentationDetents([.medium])
  }

}

#Preview {
  let viewModel = HabitViewModel.preview
  let today = Date()
  let year = viewModel.utils.year(for: today)

  WeekView(
    habitID: viewModel.habits.first.unsafelyUnwrapped.key,
    year: year)
    .environmentObject(viewModel)
}
