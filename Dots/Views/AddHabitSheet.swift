// Created by manny_lopez on 12/30/24.

import SwiftUI
import UIKit

struct AddHabitSheet: View {

  @EnvironmentObject var viewModel: HabitViewModel

  // MARK: Internal

  var body: some View {
    NavigationView {
      Form {
        Section {
          TextField("Goal name", text: $goalName)
            .focused($isTextFieldFocused)
            .showKeyboardImmediately()
        } footer: {
          Text("What goal would you like to track?")
        }
      }
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button("Cancel") {
            isPresented = false
          }
        }
        ToolbarItem(placement: .confirmationAction) {
          Button("Add") {
            if !goalName.isEmpty {
              viewModel.addHabit(name: goalName)
              isPresented = false
            }
          }
          .disabled(goalName.isEmpty)
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
  @State private var goalName = ""
  @Binding var isPresented: Bool

}

#Preview {
  struct PreviewWrapper: View {
    @State var isPresented = true

    var body: some View {
      AddHabitSheet(isPresented: $isPresented)
    }
  }
  return PreviewWrapper()
//  @Previewable @State var isPresented = true
//  return AddHabitSheet(isPresented: $isPresented)
}
