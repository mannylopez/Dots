// Created by manny_lopez on 1/11/25.

import Foundation

struct CoreDataTransformer {
  static func encode<T: Encodable>(_ value: T) -> Data? {
    try? JSONEncoder().encode(value)
  }

  static func decode<T: Decodable>(_ data: Data?) -> T? {
    guard let data else { return nil }
    return try? JSONDecoder().decode(T.self, from: data)
  }
}
