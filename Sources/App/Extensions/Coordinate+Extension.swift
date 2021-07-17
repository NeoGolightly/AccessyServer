//
//  File.swift
//  File
//
//  Created by Michael Helmbrecht on 17.07.21.
//

import FluentPostGIS


extension Coordinate {
  init(geographicPoint2D: GeographicPoint2D) {
    self.init(latitude: geographicPoint2D.latitude, longitude: geographicPoint2D.longitude)
  }
}

