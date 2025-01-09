// Created by manny_lopez on 01/07/25.

import XCTest
@testable import Dots

final class HabitViewModelTests: XCTestCase {

  var sut: HabitViewModel!
  var testHabit: Habit!
  var habitID: UUID!

  override func setUp() {
    super.setUp()
    sut = HabitViewModel(habits: [])
    habitID = UUID()
    testHabit = Habit(id: habitID, name: "Test Habit", color: .red)
    sut.habits[habitID] = testHabit
  }

  override func tearDown() {
    sut = nil
    testHabit = nil
    habitID = nil
    super.tearDown()
  }

  // MARK: - updateNote

  func test_updateNote_whenHabitDoesNotExist_doesNothing() {
    // Given
    let nonExistentID = UUID()
    let date = Date()

    // When
    sut.updateNote(habitID: nonExistentID, date: date, note: "Test note")

    // Then
    XCTAssertNil(sut.habits[nonExistentID])
  }

  func test_updateNote_whenAddingNewNote_addsNoteForDate() {
    // Given
    let date = Date()
    let note = "Test note"

    // When
    sut.updateNote(habitID: habitID, date: date, note: note)

    // Then
    XCTAssertEqual(sut.habits[habitID]?.note(for: date), note)
  }

  func test_updateNote_whenPassingNil_removesExistingNote() {
    // Given
    let date = Date()
    let note = "Initial note"
    sut.updateNote(habitID: habitID, date: date, note: note)
    XCTAssertEqual(sut.habits[habitID]?.note(for: date), note)
    
    // When
    sut.updateNote(habitID: habitID, date: date, note: nil)

    // Then
    XCTAssertNil(sut.habits[habitID]?.note(for: date))
  }

  func test_updateNote_whenUpdatingExistingNote_replacesOldNote() {
    // Given
    let date = Date()
    let initialNote = "Initial note"
    let updatedNote = "Updated note"
    sut.updateNote(habitID: habitID, date: date, note: initialNote)
    XCTAssertEqual(sut.habits[habitID]?.note(for: date), initialNote)

    // When
    sut.updateNote(habitID: habitID, date: date, note: updatedNote)

    // Then
    XCTAssertEqual(sut.habits[habitID]?.note(for: date), updatedNote)
  }

  func test_updateNote_whenNotesExistForDifferentDates_maintainsOtherNotes() {
    // Given
    let date1 = Date()
    let date2 = Calendar.current.date(byAdding: .day, value: 1, to: date1)!
    let note1 = "Note 1"
    let note2 = "Note 2"

    // When
    sut.updateNote(habitID: habitID, date: date1, note: note1)
    sut.updateNote(habitID: habitID, date: date2, note: note2)

    // Then
    XCTAssertEqual(sut.habits[habitID]?.note(for: date1), note1)
    XCTAssertEqual(sut.habits[habitID]?.note(for: date2), note2)
  }

  func test_updateNote_whenUpdatingNoteForSameDayDifferentTime_updatesExistingNote() {
    // Given
    let baseDate = Calendar.current.startOfDay(for: Date())
    print("baseDate", baseDate)
    let sameDate = Calendar.current.date(byAdding: .hour, value: 2, to: baseDate)!
    print("sameDate", sameDate)
    let initialNote = "Initial note"
    let updatedNote = "Updated note"

    // When
    sut.updateNote(habitID: habitID, date: baseDate, note: initialNote)
    XCTAssertEqual(sut.habits[habitID]?.note(for: baseDate), initialNote)
    sut.updateNote(habitID: habitID, date: sameDate, note: updatedNote)

    // Then
    XCTAssertEqual(sut.habits[habitID]?.note(for: baseDate), updatedNote)
    XCTAssertEqual(sut.habits[habitID]?.note(for: sameDate), updatedNote)
    XCTAssertEqual(sut.habits[habitID]?.notes.count, 1)
  }

  // MARK: - toggleHabit

  func test_toggleHabit_whenHabitDoesNotExist_doesNothing() {
    // Given
    let nonExistentID = UUID()
    let date = Date()

    // When
    sut.toggleHabit(habitID: nonExistentID, date: date)

    // Then
    XCTAssertNil(sut.habits[nonExistentID])
  }

  func test_toggleHabit_whenDateNotCompleted_addsDate() {
    // Given
    let date = Date()

    // When
    sut.toggleHabit(habitID: habitID, date: date)

    // Then
    XCTAssertTrue(sut.habits[habitID]?.isCompleted(for: date) ?? false)
  }

  func test_toggleHabit_whenDateAlreadyCompleted_removesDate() {
    // Given
    let date = Date()
    sut.toggleHabit(habitID: habitID, date: date) // First toggle to add
    XCTAssertTrue(sut.habits[habitID]?.isCompleted(for: date) ?? false)

    // When
    sut.toggleHabit(habitID: habitID, date: date) // Second toggle to remove

    // Then
    XCTAssertFalse(sut.habits[habitID]?.isCompleted(for: date) ?? true)
  }

  func test_toggleHabit_whenTogglingMultipleDates_maintainsCorrectState() {
    // Given
    let date1 = Date()
    let date2 = Calendar.current.date(byAdding: .day, value: 1, to: date1)!

    // When
    sut.toggleHabit(habitID: habitID, date: date1)
    sut.toggleHabit(habitID: habitID, date: date2)

    // Then
    XCTAssertTrue(sut.habits[habitID]?.isCompleted(for: date1) ?? false)
    XCTAssertTrue(sut.habits[habitID]?.isCompleted(for: date2) ?? false)

    // When toggling one off
    sut.toggleHabit(habitID: habitID, date: date1)

    // Then
    XCTAssertFalse(sut.habits[habitID]?.isCompleted(for: date1) ?? true)
    XCTAssertTrue(sut.habits[habitID]?.isCompleted(for: date2) ?? false)
  }

  func test_toggleHabit_whenTogglingDateWithDifferentTimeComponents_handlesAsSameDay() {
    // Given
    let baseDate = Calendar.current.startOfDay(for: Date())
    let sameDate = Calendar.current.date(byAdding: .hour, value: 2, to: baseDate)!

    // When
    sut.toggleHabit(habitID: habitID, date: baseDate)
    XCTAssertTrue(sut.habits[habitID]?.isCompleted(for: baseDate) ?? false)

    // Then
    XCTAssertTrue(sut.habits[habitID]?.isCompleted(for: sameDate) ?? false)

    // When toggling with different time
    sut.toggleHabit(habitID: habitID, date: sameDate)

    // Then
    XCTAssertFalse(sut.habits[habitID]?.isCompleted(for: baseDate) ?? true)
    XCTAssertFalse(sut.habits[habitID]?.isCompleted(for: sameDate) ?? true)
  }

  func test_toggleHabit_whenTogglingMultipleTimes_correctlyTogglesState() {
    // Given
    let date = Date()

    // When/Then - First toggle
    sut.toggleHabit(habitID: habitID, date: date)
    XCTAssertTrue(sut.habits[habitID]?.isCompleted(for: date) ?? false)

    // When/Then - Second toggle
    sut.toggleHabit(habitID: habitID, date: date)
    XCTAssertFalse(sut.habits[habitID]?.isCompleted(for: date) ?? true)

    // When/Then - Third toggle
    sut.toggleHabit(habitID: habitID, date: date)
    XCTAssertTrue(sut.habits[habitID]?.isCompleted(for: date) ?? false)
  }
}
