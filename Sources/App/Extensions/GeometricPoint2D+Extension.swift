//
//  File.swift
//  File
//
//  Created by Michael Helmbrecht on 17.07.21.
//

import FluentPostGIS


extension GeometricPoint2D {
  init(coordinate: Coordinate) {
    self.init(x: coordinate.longitude, y: coordinate.latitude)
  }
}
