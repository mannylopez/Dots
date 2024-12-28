// Created by manny_lopez on 12/26/24.

import XCTest
@testable import Dots

final class DotsTests: XCTestCase {

  func test_daysInMonth() {
    let utils = CalendarUtils.shared
    var daysInMonth = utils.daysInMonth(month: 1, year: 2024)
    XCTAssertEqual(daysInMonth, 1..<32)

    daysInMonth = utils.daysInMonth(month: 2, year: 2024)
    XCTAssertEqual(daysInMonth, 1..<30)

    daysInMonth = utils.daysInMonth(month: 3, year: 2024)
    XCTAssertEqual(daysInMonth, 1..<32)

    daysInMonth = utils.daysInMonth(month: 4, year: 2024)
    XCTAssertEqual(daysInMonth, 1..<31)

    daysInMonth = utils.daysInMonth(month: 5, year: 2024)
    XCTAssertEqual(daysInMonth, 1..<32)

    daysInMonth = utils.daysInMonth(month: 6, year: 2024)
    XCTAssertEqual(daysInMonth, 1..<31)

    daysInMonth = utils.daysInMonth(month: 7, year: 2024)
    XCTAssertEqual(daysInMonth, 1..<32)

    daysInMonth = utils.daysInMonth(month: 8, year: 2024)
    XCTAssertEqual(daysInMonth, 1..<32)

    daysInMonth = utils.daysInMonth(month: 9, year: 2024)
    XCTAssertEqual(daysInMonth, 1..<31)

    daysInMonth = utils.daysInMonth(month: 10, year: 2024)
    XCTAssertEqual(daysInMonth, 1..<32)

    daysInMonth = utils.daysInMonth(month: 11, year: 2024)
    XCTAssertEqual(daysInMonth, 1..<31)

    daysInMonth = utils.daysInMonth(month: 12, year: 2024)
    XCTAssertEqual(daysInMonth, 1..<32)
  }

  func test_firstDayOfMonth() {
    let utils = CalendarUtils.shared

    // Where
    // 0: Sunday
    // 1: Monday
    // 2: Tuesday
    // 3: Wednesday
    // 4: Thursday
    // 5: Friday
    // 6: Saturday

    var firstDay = utils.firstDayOfMonth(month: 1, year: 2024)
    XCTAssertEqual(firstDay, 1) // Monday

    firstDay = utils.firstDayOfMonth(month: 2, year: 2024)
    XCTAssertEqual(firstDay, 4) // Thursday

    firstDay = utils.firstDayOfMonth(month: 3, year: 2024)
    XCTAssertEqual(firstDay, 5) // Friday

    firstDay = utils.firstDayOfMonth(month: 4, year: 2024)
    XCTAssertEqual(firstDay, 1)

    firstDay = utils.firstDayOfMonth(month: 5, year: 2024)
    XCTAssertEqual(firstDay, 3)

    firstDay = utils.firstDayOfMonth(month: 6, year: 2024)
    XCTAssertEqual(firstDay, 6)

    firstDay = utils.firstDayOfMonth(month: 7, year: 2024)
    XCTAssertEqual(firstDay, 1)

    firstDay = utils.firstDayOfMonth(month: 8, year: 2024)
    XCTAssertEqual(firstDay, 4)

    firstDay = utils.firstDayOfMonth(month: 9, year: 2024)
    XCTAssertEqual(firstDay, 0)

    firstDay = utils.firstDayOfMonth(month: 10, year: 2024)
    XCTAssertEqual(firstDay, 2)

    firstDay = utils.firstDayOfMonth(month: 11, year: 2024)
    XCTAssertEqual(firstDay, 5)

    firstDay = utils.firstDayOfMonth(month: 12, year: 2024)
    XCTAssertEqual(firstDay, 0)
  }

  // TODO: Refactor this
  func test_dayToday() {
    let utils = CalendarUtils.shared
    XCTAssertEqual(utils.dayToday(), 28)
  }

  func test_monthName() {
    let utils = CalendarUtils.shared
    XCTAssertEqual(utils.monthName(month: 1), "January")
    XCTAssertEqual(utils.monthName(month: 2), "February")
    XCTAssertEqual(utils.monthName(month: 3), "March")
    XCTAssertEqual(utils.monthName(month: 4), "April")
    XCTAssertEqual(utils.monthName(month: 5), "May")
    XCTAssertEqual(utils.monthName(month: 6), "June")
    XCTAssertEqual(utils.monthName(month: 7), "July")
    XCTAssertEqual(utils.monthName(month: 8), "August")
    XCTAssertEqual(utils.monthName(month: 9), "September")
    XCTAssertEqual(utils.monthName(month: 10), "October")
    XCTAssertEqual(utils.monthName(month: 11), "November")
    XCTAssertEqual(utils.monthName(month: 12), "December")
  }

  // Habit tests

  // TODO: Refactor this
  func test_habit() {
    let nonZeroDates = Set(arrayLiteral: Date())
    let habit = Habit(name: "Run", nonZeroDates: nonZeroDates)
    let viewModel = HabitViewModel(habit: habit)
    let nonZeroDatesArr = viewModel.nonZeroDatesFor(month: 12, year: 2024)
    XCTAssertEqual(nonZeroDatesArr.count, 1)
  }

}
