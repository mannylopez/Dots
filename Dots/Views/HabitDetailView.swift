//
//  HabitDetailView.swift
//  Dots
//
//  Created by Manuel Lopez on 5/5/25.
//

import SwiftUI

struct HabitDetailView: View {
  
  init(
    habit: Habit,
    month: Int,
    year: Int)
  {
    self.habit = habit
    self.month = month
    self.year = year
  }
  
  var body: some View {
    VStack {
      
      MonthView(
        habitID: habit.id,
        month: month,
        year: year)
      
      addNotSheetContent(
        dayModel: DayModel(
          id: habit.id,
          day: 5,
          note: viewModel.note(
            for: createDate(using: 5),
            habitID: habit.id),
          date: createDate(using: 5)))
    }
  }
  
  private let habit: Habit
  private var month: Int
  private let year: Int
  
  @State private var noteText = ""
  @State private var selectedDayModel: DayModel? = nil
  
  @EnvironmentObject private var viewModel: HabitViewModel
  
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
  
  private func createDate(using day: Int) -> Date {
    viewModel.utils.createDate(
      year: year,
      month: month,
      day: day)
  }
  
  private var days: Range<Int> {
    viewModel.utils.daysInMonth(month: month, year: year)
  }
}

#Preview {
  let viewModel = HabitViewModel.preview
  let today = Date()
  HabitDetailView(
    habit: viewModel.habitList.first!,
    month: viewModel.utils.month(for: today),
    year: viewModel.utils.year(for: today))
  .environmentObject(viewModel)
}
