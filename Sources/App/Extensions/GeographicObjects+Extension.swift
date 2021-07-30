//
//  File.swift
//  File
//
//  Created by Michael Helmbrecht on 17.07.21.
//

import FluentPostGIS
import AccessyDataTypes

extension GeographicPoint2D {
  init(coordinate: Coordinate) {
    self.init(longitude: coordinate.longitude, latitude: coordinate.latitude)
  }
}

extension GeographicLineString2D {
  init(coordinates: [Coordinate]) {
    self.init(points: coordinates.map{ GeographicPoint2D(coordinate: $0) })
  }
  
  func toCoordinates() -> [Coordinate] {
    points.map{ Coordinate(geographicPoint2D: $0) }
  }
  
}


extension GeographicGeometryCollection2D {
  var allPoint2D: [GeographicPoint2D] {
    geometries.compactMap{ $0 as? GeographicPoint2D}
  }
}
