// Created by manny_lopez on 12/25/24.

import SwiftUI

@main
struct DotsApp: App {
  @StateObject private var dataController = DataController.shared

  var body: some Scene {
    WindowGroup {
      HabitList()
        .environment(\.managedObjectContext, dataController.persistentContainer.viewContext)
        .environmentObject(HabitViewModel(context: dataController.persistentContainer.viewContext))
    }
  }
}
