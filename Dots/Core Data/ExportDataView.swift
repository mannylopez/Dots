// Created by manny_lopez on 4/10/25.
// Copyright © 2025 Airbnb Inc. All rights reserved.

import CoreData
import SwiftUI

// MARK: - ExportDataView

struct ExportDataView: View {

  // MARK: Internal

  @ObservedObject var habitViewModel: HabitViewModel

  var body: some View {
    Button("Export Habits as JSON") {
      exportHabitsDataAsJSON()
    }
    .padding()
    .background(Color.blue)
    .foregroundColor(.white)
    .cornerRadius(8)
    .sheet(isPresented: $showShareSheet) {
      if let url = exportedFileURL {
        ShareSheet(items: [url])
      }
    }
  }

  func exportHabitsDataAsJSON() {
    // Create an array of dictionaries representing habits
    var habitsArray: [[String: Any]] = []
    let localDateFormatter = ISO8601DateFormatter()

    for habit in habitViewModel.habitList {
      var habitDict: [String: Any] = [
        "id": habit.id.uuidString,
        "name": habit.name,
        "color": habit.color.toHex(),
        "creationDate": localDateFormatter.string(from: habit.creationDate),
      ]

      // Convert completed dates to timestamp array
      let completedDatesArray = habit.completedDates.map { localDateFormatter.string(from: $0) }
      habitDict["completedDates"] = completedDatesArray

      // Convert notes dictionary to use timestamps as keys
      var notesDict: [String: String] = [:]
      for (date, note) in habit.notes {
        notesDict["\(localDateFormatter.string(from: date))"] = note
      }
      habitDict["notes"] = notesDict

      habitsArray.append(habitDict)
    }

    // Create a top-level dictionary with metadata
    let exportDict: [String: Any] = [
      "exportDate": localDateFormatter.string(from: Date()),
      "exportVersion": "1.0",
      "habits": habitsArray,
    ]

    // Convert to JSON
    do {
      let jsonData = try JSONSerialization.data(withJSONObject: exportDict, options: .prettyPrinted)

      // Create a file in the temporary directory
      let tempDirectoryURL = FileManager.default.temporaryDirectory
      let fileURL = tempDirectoryURL.appendingPathComponent("HabitTrackerExport_\(Date().formatted(.iso8601)).json")

      // Write to file
      try jsonData.write(to: fileURL)

      // Store the URL for sharing
      exportedFileURL = fileURL
      showShareSheet = true
    } catch {
      print("Failed to export JSON data: \(error.localizedDescription)")
    }
  }

  // MARK: Private

  @State private var exportedFileURL: URL?
  @State private var showShareSheet = false

}

// MARK: - ShareSheet

/// Helper view to present the share sheet
struct ShareSheet: UIViewControllerRepresentable {
  var items: [Any]

  func makeUIViewController(context _: Context) -> UIActivityViewController {
    UIActivityViewController(activityItems: items, applicationActivities: nil)
  }

  func updateUIViewController(_: UIActivityViewController, context _: Context) { }
}
