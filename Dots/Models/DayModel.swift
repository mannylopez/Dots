//
//  DayModel.swift
//  Dots
//
//  Created by Manuel Lopez on 5/5/25.
//

import Foundation

struct DayModel: Identifiable, Equatable {
  let id: UUID
  let day: Int
  let note: String?
  let date: Date
}
