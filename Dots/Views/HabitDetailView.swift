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
        year: year) { localDay in
          day = localDay
          selectedDayModel = DayModel(
            id: habit.id,
            day: day,
            note: viewModel.note(
              for: createDate(using: day),
              habitID: habit.id),
            date: createDate(using: day))
          
//          if let note = selectedDayModel?.note {
//            
//            noteText = note
//          }
        }
      
      if let selectedDayModel {
        
        addNotSheetContent(
          dayModel: selectedDayModel)
        .padding(.top, 16)
      }
    }
    .onAppear {
      let today = Date()
      let dayToday = viewModel.utils.day(for: today)
      selectedDayModel = DayModel(
        id: habit.id,
        day: dayToday,
        note: viewModel.note(for: today, habitID: habit.id),
        date: today)
    }
  }
  
  private let habit: Habit
  private var month: Int
  private let year: Int
  
  
  
  @State private var day: Int = 1
  @State private var noteText = ""
  @State private var selectedDayModel: DayModel?
  
  @EnvironmentObject private var viewModel: HabitViewModel
  
  
  private func addNotSheetContent(dayModel: DayModel) -> some View {
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
        .onChange(of: selectedDayModel) { newValue in
          noteText = newValue?.note ?? ""
        }
        .onChange(of: noteText) { newValue in
          viewModel.updateNote(habitID: dayModel.id, date: dayModel.date, note: newValue)
        }
    }
    
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
