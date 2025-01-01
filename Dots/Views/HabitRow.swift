// Created by manny_lopez on 12/29/24.

import SwiftUI

struct HabitRow: View {
  let title: String
  let habitID: UUID?

  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 25)
        .fill(.background)
        .shadow(radius: 10)
      VStack {
        Text(title)
          .font(.title2)
//          .padding(.bottom, -20)
//          .padding()
        if let habitID {
          MonthView(habitID: habitID, month: 1, year: 2025)
        }
      }
      .padding()
    }
//    .frame(maxWidth: .infinity, alignment: .leading)
//    .frame(maxWidth: .infinity, maxHeight: 50)
  }
}

#Preview {
  let viewModel = HabitViewModel()
  let id = viewModel.habits.first.unsafelyUnwrapped.key
  return HabitRow(title: "Stretch", habitID: id)
    .environmentObject(viewModel)
}
