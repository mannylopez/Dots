// Created by manny_lopez on 12/30/24.

import SwiftUI
import UIKit

// MARK: - AddHabitSheet

struct AddHabitSheet: View {

  @EnvironmentObject var viewModel: HabitViewModel

  // MARK: Internal

  var body: some View {
    NavigationStack {
      Form {
        colorPicker(color: $color)
        goalNameTextField()
        Toggle("Western numbers", isOn: $viewModel.isWesternNumeral)
      }
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          cancelButton()
        }
        ToolbarItem(placement: .confirmationAction) {
          addButton()
        }
      }
      .onAppear {
        isTextFieldFocused = true
      }
    }
    .ignoresSafeArea(.keyboard)
  }

  // MARK: Private

  @FocusState private var isTextFieldFocused: Bool
  @State private var habitName = ""
  @Binding var isPresented: Bool
  @State var color = Color.green.opacity(0.4)

  @ViewBuilder
  private func goalNameTextField() -> some View {
    TextField("Goal name", text: $habitName)
      .focused($isTextFieldFocused)
      .showKeyboardImmediately()
  }

  @ViewBuilder
  private func cancelButton() -> some View {
    Button("Cancel") {
      isPresented = false
    }
  }

  @ViewBuilder
  private func addButton() -> some View {
    Button("Add") {
      if !habitName.isEmpty {
        viewModel.addHabit(
          name: habitName,
          color: color)
        isPresented = false
      }
    }
    .disabled(habitName.isEmpty)
  }

}

#Preview {
  struct PreviewWrapper: View {
    @State var isPresented = true
    let viewModel = HabitViewModel.preview

    var body: some View {
      AddHabitSheet(isPresented: $isPresented)
        .environmentObject(viewModel)
    }
  }
  return PreviewWrapper()
}
