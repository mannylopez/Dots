// Created by manny_lopez on 12/29/24.

import SwiftUI

// MARK: - HabitRow

struct HabitRow: View {
  let title: String
  let habitID: UUID?

  var body: some View {
    HabitRowContent(title: title, habitID: habitID)
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
      .background(Color(.systemBackground))
      .cornerRadius(24)
      .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 2)
      .overlay(
        RoundedRectangle(cornerRadius: 24)
          .stroke(.gray.opacity(0.2), lineWidth: 1))
//    .padding(.top, 16)
      .padding(.horizontal, 24)
  }
}

// MARK: - _HabitRowCollapsed

struct _HabitRowCollapsed: View {
  let title: String

  var body: some View {
    HStack {
      Text(title)
      Spacer()
      Button(">") {
        print("i")
      }
    }
    .padding(.top, 5)
  }
}

// MARK: - _HabitRowExpanded

struct HabitRowContent: View {
  let title: String
  let habitID: UUID?

  var body: some View {
    VStack {
      HStack {
        Text(title)
          .frame(maxWidth: .infinity, alignment: .leading)
        Image(systemName: "chevron.right").opacity(0.3)
      }
      .font(.title2)
      .padding([.leading, .trailing, .top], 24)
      .padding(.bottom, habitID != nil ? -20 : 0)
      if let habitID {
        MonthView(habitID: habitID, month: 1, year: 2025)
      }
    }
    .padding(.bottom, 24)
  }
}

#Preview {
  let viewModel = HabitViewModel()
  let id = viewModel.habits.first.unsafelyUnwrapped.key
  return HabitRow(title: "Stretch", habitID: id)
    .environmentObject(viewModel)
}
