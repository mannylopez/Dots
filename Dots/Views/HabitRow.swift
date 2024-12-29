// Created by manny_lopez on 12/29/24.

import SwiftUI

struct HabitRow: View {
  let title: String

  var body: some View {
    Text(title)
      .frame(maxWidth: .infinity, alignment: .leading)
  }
}

#Preview {
  HabitRow(title: "Stretch")
}
