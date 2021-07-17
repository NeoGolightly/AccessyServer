//
//  File.swift
//  File
//
//  Created by Michael Helmbrecht on 17.07.21.
//

import FluentPostGIS


extension GeographicPoint2D {
  init(coordinate: Coordinate) {
    self.init(longitude: coordinate.longitude, latitude: coordinate.latitude)
  }
}
