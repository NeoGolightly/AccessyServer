//
//  File.swift
//  
//
//  Created by Michael Helmbrecht on 13.07.21.
//

import Vapor
import Fluent
import FluentPostGIS

extension Sidewalk: Content {}

final class Sidewalk: Model {
  static var schema: String = Sidewalk.v0_0_1_Beta.schema
  
  @ID(key: .id)
  var id: UUID?
  
  @Field(key: Sidewalk.v0_0_1_Beta.pathCoordinates)
  var pathCoordinates: [Coordinate]
  
  @Field(key: Sidewalk.v0_0_1_Beta.nodesCoordinates)
  var nodesCoordinate: GeographicGeometryCollection2D
  
  @Timestamp(key: Sidewalk.v0_0_1_Beta.createdAt, on: .create)
  var createdAt: Date?
  
  @Timestamp(key: Sidewalk.v0_0_1_Beta.updatedAt, on: .update)
  var updatedAt: Date?
  
  @Timestamp(key: Sidewalk.v0_0_1_Beta.deletedAt, on: .delete)
  var deletedAt: Date?
  
  init(){}
  
  init(id: UUID? = nil,
       pathCoordinates: [Coordinate] = [],
       nodesCoordinate: GeographicGeometryCollection2D) {
    self.id = id
    self.pathCoordinates = pathCoordinates
    self.nodesCoordinate = nodesCoordinate
  }
}
