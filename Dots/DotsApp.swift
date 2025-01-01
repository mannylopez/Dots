// Created by manny_lopez on 12/25/24.

import SwiftUI

@main
struct DotsApp: App {
  @StateObject private var viewModel = HabitViewModel()

  var body: some Scene {
    WindowGroup {
//      NavigationView {
        HabitList()
//      }
      .environmentObject(viewModel)
    }
  }
}
