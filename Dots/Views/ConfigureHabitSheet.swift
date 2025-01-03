// Created by manny_lopez on 1/2/25.

import SwiftUI

struct ConfigureHabitSheet: View {

  @EnvironmentObject var viewModel: HabitViewModel
  @Binding var isPresented: Bool
  @State private var showingAlert = false

  let habit: Habit

  @State var name: String
  @State var color: Color
  var dismissToRoot: () -> Void

  var body: some View {
    Form {
      Section {
        TextField(habit.name, text: $name)
        colorPicker()
      }
      Section {
        saveChangesButton()
      }
      Section {
        deleteHabitButton()
      }
    }
  }

  @ViewBuilder
  private func colorPicker() -> some View {
    ColorPicker(selection: $color) {
      HStack {
        Text("Color")
        Spacer()
        DateView(date: 1, isCompleted: true, addBorder: false, fillColor: color)
        DateView(date: 25, isCompleted: true, addBorder: false, fillColor: color)
        DateView(date: 31, isCompleted: true, addBorder: false, fillColor: color)
      }
    }
  }

  @ViewBuilder
  private func saveChangesButton() -> some View {
    Button {
      viewModel.updateHabit(
        habitID: habit.id,
        name: name,
        color: color)

      isPresented = false
    } label: {
      HStack {
        Image(systemName: "checkmark.circle.fill")
        Text("Save Changes")
      }
      .frame(maxWidth: .infinity)
      .foregroundStyle(.green)
    }
  }

  @ViewBuilder
  private func deleteHabitButton() -> some View {
    Button {
      showingAlert = true
    } label: {
      HStack {
        Image(systemName: "x.circle.fill")
        Text("Delete Goal")
      }
      .frame(maxWidth: .infinity)
      .foregroundStyle(.red)
    }
    .alert("Delete goal? \nThis is not reversible.", isPresented: $showingAlert) {
      Button("Cancel", role: .cancel) { }
      Button("Delete", role: .destructive) {
        viewModel.deleteHabit(habitID: habit.id)
        isPresented = false
        dismissToRoot()
      }
    }
  }
}

#Preview {
  struct PreviewWrapper: View {
    @State var isPresented = true
    let habit = SampleHabitsHelper.generate().first!

    var body: some View {
      ConfigureHabitSheet(
        isPresented: $isPresented,
        habit: habit,
        name: habit.name,
        color: habit.color,
        dismissToRoot: { })
    }
  }
  return PreviewWrapper()
}
