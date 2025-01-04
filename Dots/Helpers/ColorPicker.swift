// Created by manny_lopez on 1/3/25.

import SwiftUI

extension View {
  @ViewBuilder
  func colorPicker(color: Binding<Color>) -> some View {
    ColorPicker(selection: color) {
      HStack {
        Text("Color")
        Spacer()
        DateView(
          date: 1,
          isCompleted: true,
          addBorder: false,
          fillColor: color.wrappedValue)
        DateView(
          date: 31,
          isCompleted: true,
          addBorder: true,
          fillColor: color.wrappedValue)
      }
    }
  }
}
