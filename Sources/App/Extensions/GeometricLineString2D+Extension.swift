//
//  File.swift
//  File
//
//  Created by Michael Helmbrecht on 17.07.21.
//

import FluentPostGIS

extension GeometricLineString2D {
  init(coordinates: [Coordinate]) {
    self.init(points: coordinates.map{ GeometricPoint2D(coordinate: $0) })
  }
  
  func toCoordinates() -> [Coordinate] {
    points.map{ Coordinate(geometricPoint2D: $0) }
  }
  
}

