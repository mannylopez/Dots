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
    XCTAssertEqual(firstDay, 5) // Thursday

    firstDay = utils.firstDayOfMonth(month: 4, year: 2024)
    XCTAssertEqual(firstDay, 1) // Thursday

    firstDay = utils.firstDayOfMonth(month: 5, year: 2024)
    XCTAssertEqual(firstDay, 3) // Thursday

    firstDay = utils.firstDayOfMonth(month: 6, year: 2024)
    XCTAssertEqual(firstDay, 6) // Thursday

    firstDay = utils.firstDayOfMonth(month: 7, year: 2024)
    XCTAssertEqual(firstDay, 1) // Thursday

    firstDay = utils.firstDayOfMonth(month: 8, year: 2024)
    XCTAssertEqual(firstDay, 4) // Thursday

    firstDay = utils.firstDayOfMonth(month: 9, year: 2024)
    XCTAssertEqual(firstDay, 0) // Thursday

    firstDay = utils.firstDayOfMonth(month: 10, year: 2024)
    XCTAssertEqual(firstDay, 2) // Thursday

    firstDay = utils.firstDayOfMonth(month: 11, year: 2024)
    XCTAssertEqual(firstDay, 5) // Thursday

    firstDay = utils.firstDayOfMonth(month: 12, year: 2024)
    XCTAssertEqual(firstDay, 0) // Thursday
  }

}
