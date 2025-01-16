// Created by manny_lopez on 12/25/24.

import CoreData
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
        ForEach(0..<startOffset, id: \.self) { index in
          Text("")
            .foregroundStyle(.secondary)
            .id("\(monthIdentifier)-offset-\(index)-\(UUID())")
        }

        ForEach(days, id: \.self) { day in
          let date = createDate(using: day)
          let isCompleted = viewModel.isCompleted(date: date, habitID: habitID)
          DateView(
            date: day,
            isCompleted: isCompleted,
            addBorder: isToday(date: date),
            fillColor: fillColor())
          .id("\(monthIdentifier)-offset-\(day)")
            .onTapGesture {
              viewModel.toggleHabit(habitID: habitID, date: date)
              if !isCompleted {
                UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
              }
            }
            .onLongPressGesture {
              selectedDayModel = DayModel(
                id: habitID,
                day: day,
                note: viewModel.note(for: date, habitID: habitID),
                date: date)
            }
        }
      }
    }
    .sheet(item: $selectedDayModel) { dayModel in
      addNotSheetContent(dayModel: dayModel)
    }
  }

  // MARK: Private

  private struct DayModel: Identifiable {
    let id: UUID
    let day: Int
    let note: String?
    let date: Date
  }

  @State private var noteText = ""
  @State private var showingNoteSheet = false
  @State private var selectedDayModel: DayModel? = nil

  @EnvironmentObject private var viewModel: HabitViewModel

  private let columns: [GridItem] = Array(repeating: GridItem(.fixed(25)), count: 7)
  private let habitID: UUID
  private let month: Int
  private let year: Int

  private var monthIdentifier: String {
        "\(year)-\(month)"
    }

  private var days: Range<Int> {
    viewModel.utils.daysInMonth(month: month, year: year)
  }

  private var startOffset: Int {
    viewModel.utils.firstDayOfMonth(month: month, year: year)
  }

  private var monthName: String {
    viewModel.utils.monthName(month: month)
  }

  private func createDate(using day: Int) -> Date {
    viewModel.utils.createDate(year: year, month: month, day: day)
  }

  private func isToday(date: Date) -> Bool {
    viewModel.utils.isToday(date: date)
  }

  private func fillColor() -> Color {
    guard let habit = viewModel.habits[habitID] else { return .green }
    return habit.color
  }

  @ViewBuilder
  private func addNotSheetContent(dayModel: DayModel) -> some View {
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
  let month = viewModel.utils.month(for: today)
  let year = viewModel.utils.year(for: today)

  MonthView(
    habitID: viewModel.habits.first.unsafelyUnwrapped.key,
    month: month,
    year: year)
    .environmentObject(viewModel)
}
