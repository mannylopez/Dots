// Created by manny_lopez on 1/8/25.

import CoreData
import Foundation

class DataController: ObservableObject {
  static let shared = DataController()

  let persistentContainer: NSPersistentContainer

  init() {
    persistentContainer = NSPersistentContainer(name: "HabitTracker")

    persistentContainer.loadPersistentStores { description, error in
      if let error {
        fatalError("Core Data failed to load: \(error.localizedDescription)")
      }
    }
    persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
  }

  /// Delete existing store if it exists
  private func deleteTheExistingStore() {
    if let storeURL = persistentContainer.persistentStoreDescriptions.first?.url {
        try? persistentContainer.persistentStoreCoordinator.destroyPersistentStore(at: storeURL, ofType: NSSQLiteStoreType, options: nil)
    }
  }
}
