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
      title: title,
      habitID: habitID,
      month: month,
      year: year)
      .frame(
        maxWidth: .infinity,
        maxHeight: .infinity,
        alignment: .top)
      .background(Color(.systemBackground))
      .cornerRadius(24)
      .adaptiveShadow(x: 0, y: 2, opacity: 0.3)
      .overlay {
        RoundedRectangle(cornerRadius: 24)
          .stroke(.gray.opacity(0.2), lineWidth: 1)
      }
      .padding(.horizontal, 24)
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
          .imageScale(.small)
          .opacity(0.5)
      }
      .font(.title2)
      .padding([.leading, .trailing], 24)
      .padding(.top, 20)
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
  let viewModel = HabitViewModel.preview
  let today = Date()

  HabitRow(
    title: title,
    habitID: viewModel.habitList.first!.id,
    month: viewModel.utils.month(for: today),
    year: viewModel.utils.year(for: today))
    .environmentObject(viewModel)
}
