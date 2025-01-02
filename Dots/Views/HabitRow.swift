// Created by manny_lopez on 12/29/24.

import SwiftUI

// MARK: - HabitRow

struct HabitRow: View {
  let title: String
  let habitID: UUID?
  let month: Int
  let year: Int

  var body: some View {
    RowContent(
      title: title, habitID:
        habitID,
      month: month,
      year: year)
      .frame(
        maxWidth: .infinity,
        maxHeight: .infinity,
        alignment: .leading)
      .background(Color(.systemBackground))
      .overlay {
        RoundedRectangle(cornerRadius: 24)
          .stroke(.gray.opacity(0.2), lineWidth: 1)
          .padding(.horizontal, 24)
        
      }
//      .shadow(
//        color: .black.opacity(0.9),
//        radius: 8,
//        x: 0,
//        y: 2)
  }
}

// MARK: - RowContent

struct RowContent: View {
  let title: String
  let habitID: UUID?
  let month: Int
  let year: Int

  var body: some View {
    VStack {
      HStack {
        Text(title)
          .frame(maxWidth: .infinity, alignment: .leading)
        Image(systemName: "chevron.right")
          .foregroundStyle(.blue)
      }
      .font(.title2)
      .padding([.leading, .trailing, .top], 24)
      .padding(.bottom, habitID != nil ? -20 : 0)
      if let habitID {
        MonthView(habitID: habitID, month: month, year: year)
      }
    }
    .padding(.bottom, 24)
  }
}

#Preview {
  let title = "Physical therapy exercises"
  let viewModel = HabitViewModel()
  let today = Date()
//  RowContent(
//    title: title,
//    habitID: viewModel.habitList.first!.id,
//    month: viewModel.utils.month(for: today),
//    year: viewModel.utils.year(for: today))
//    .environmentObject(viewModel)

  HabitRow(
    title: title,
    habitID: viewModel.habitList.first!.id,
    month: viewModel.utils.month(for: today),
    year: viewModel.utils.year(for: today))
  .environmentObject(viewModel)
}
