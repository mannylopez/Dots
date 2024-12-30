// Created by manny_lopez on 12/25/24.

import SwiftUI

@main
struct DotsApp: App {
  let today = Date()

  // TODO: Refactor this
  @StateObject private var viewModel = HabitViewModel()

  var body: some Scene {
    WindowGroup {
      // TODO: Refactor this
      HabitList()
        .environmentObject(viewModel)
    }
  }
}
