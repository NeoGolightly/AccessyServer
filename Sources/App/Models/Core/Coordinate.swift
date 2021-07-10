//
//  File.swift
//  
//
//  Created by Michael Helmbrecht on 07.07.21.
//

import Vapor
import Fluent

struct Coordinate: Codable {
  let latitude: Double
  let longitude: Double
}

extension Coordinate: Hashable {
  public static func == (lhs: Coordinate, rhs: Coordinate) -> Bool {
    return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
  }
  
  public func hash(into hasher: inout Hasher) {
    hasher.combine(self.latitude)
    hasher.combine(self.longitude)
  }
}
