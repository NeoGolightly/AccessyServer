//
//  File.swift
//  File
//
//  Created by Michael Helmbrecht on 17.07.21.
//

import FluentPostGIS

extension GeographicGeometryCollection2D {
  var allPoint2D: [GeographicPoint2D] {
    geometries.compactMap{ $0 as? GeographicPoint2D}
  }
}
