//
//  File.swift
//  File
//
//  Created by Michael Helmbrecht on 17.07.21.
//

import FluentPostGIS
import AccessyDataTypes

extension Coordinate {
  init(geographicPoint2D: GeographicPoint2D) {
    self.init(latitude: geographicPoint2D.latitude, longitude: geographicPoint2D.longitude)
  }
  
  init(geometricPoint2D: GeometricPoint2D) {
    self.init(latitude: geometricPoint2D.y, longitude: geometricPoint2D.x)
  }
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
