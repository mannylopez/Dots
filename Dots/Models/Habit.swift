// Created by manny_lopez on 12/27/24.

import SwiftUI

// MARK: - Habit

struct Habit: Identifiable, Hashable {

  // MARK: Lifecycle

  init(
    id: UUID = UUID(),
    name: String,
    color: Color,
    completedDates: Set<Date> = [],
    notes: [Date: String] = [:])
  {
    self.id = id
    self.name = name
    self.color = color
    self.completedDates = completedDates
    self.notes = notes
    creationDate = Date()
  }

  // MARK: Internal

  let id: UUID
  var name: String
  var color: Color
  var completedDates: Set<Date>
  let creationDate: Date
  var notes: [Date: String]

  // MARK: Private

  private let utils = CalendarUtils.shared

}

// MARK: Habit + Equatable

extension Habit: Equatable {
  static func ==(lhs: Habit, rhs: Habit) -> Bool {
    lhs.id == rhs.id &&
      lhs.name == rhs.name &&
      lhs.completedDates == rhs.completedDates &&
      lhs.creationDate == rhs.creationDate &&
      lhs.notes == rhs.notes
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
    hasher.combine(name)
    hasher.combine(completedDates)
    hasher.combine(creationDate)
    hasher.combine(notes)
  }
}

// MARK: Habit + Codable

extension Habit: Codable {

  // MARK: Lifecycle

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    id = try container.decode(UUID.self, forKey: .id)
    name = try container.decode(String.self, forKey: .name)
    let hexColor = try container.decode(String.self, forKey: .color)
    color = Color(hex: hexColor)
    completedDates = try container.decode(Set<Date>.self, forKey: .completedDates)
    creationDate = try container.decode(Date.self, forKey: .creationDate)
    notes = try container.decode([Date: String].self, forKey: .notes)
  }

  // MARK: Internal

  enum CodingKeys: String, CodingKey {
    case id
    case name
    case color
    case creationDate
    case completedDates
    case notes
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(id, forKey: .id)
    try container.encode(name, forKey: .name)
    try container.encode(color.toHex(), forKey: .color)
    try container.encode(completedDates, forKey: .completedDates)
    try container.encode(creationDate, forKey: .creationDate)
    try container.encode(notes, forKey: .notes)
  }

}
