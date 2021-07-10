//
//  File.swift
//  
//
//  Created by Michael Helmbrecht on 30.06.21.
//

import Fluent
import Vapor
import FluentPostGIS
import Foundation

final class Route: Model {
  static let schema = "routes"
  
  @ID(key: .id)
  var id: String?
  
  @Field(key: "name")
  var name: String?
  
  
  //  var waypoints: [Coordinate]
  //  var intermediateWaypoints: [Coordinate]
  //  var steps: [Step]
  //
  init() { }
  //  init(id: String = UUID().uuidString,
  //                name: String?,
  //                distance: Double,
  //                estimatedTime: Double,
  //                waypoints: [Coordinate],
  //                intermediateWaypoints: [Coordinate],
  //                steps: [Step]) {
  //    self.id = id
  //    self.name = name
  //    self.distance = distance
  //    self.estimatedTime = estimatedTime
  //    self.waypoints = waypoints
  //    self.intermediateWaypoints = intermediateWaypoints
  //    self.steps = steps
  //  }
}

public enum TurnType: String{
  case left, right, straight, unknown
}

public struct Step: Identifiable{
  public let id: String = UUID().uuidString
  public let distance: Double
  public let turnType: TurnType
  let waypoints: [Coordinate]
  public let bearing: Double
}

struct CreateRouteSegmentData: Content {
  let id: String
  let coordinates: [Coordinate]
}







final class LocationTest: Model {
  static let schema = "location_test"
  
  @ID(key: .id)
  var id: UUID?
  @Field(key: "location")
  var location: GeographicPoint2D
  
  init(){}
  init(id: UUID? = nil, location: GeographicPoint2D) {
    self.id = id
    self.location = location
  }
}
