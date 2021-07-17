//
//  File.swift
//  File
//
//  Created by Michael Helmbrecht on 17.07.21.
//

import FluentPostGIS

extension GeographicLineString2D {
  init(coordinates: [Coordinate]) {
    self.init(points: coordinates.map{ GeographicPoint2D(coordinate: $0) })
  }
}

