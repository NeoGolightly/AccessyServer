//
//  File.swift
//  File
//
//  Created by Michael Helmbrecht on 25.07.21.
//

import Vapor

///////////////////////////////////////////////////////////////
///
///
///   REQUESTS
///
///
///////////////////////////////////////////////////////////////


///
struct CreateSidewalkData: PathResponseRepresentable, Codable {
  let pathCoordinates: [Coordinate]
}

struct CenterCoordinateRequestData: Content {
  let latitude: Double
  let longitude: Double
  let radius: Double
}

//struct SidewalkRequestData: Content {
//  let pathCoordinates: [Coordinate]
//  let intersectionNodes: [String]
//}
