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

final class Sidewalk: Model, InfrastructureType {
  static var schema: String = Sidewalk.v0_0_1_Beta.schema
  
  @ID(key: .id)
  var id: UUID?
  
  @Field(key: Sidewalk.v0_0_1_Beta.pathCoordinates)
  var pathCoordinates: GeometricLineString2D
  
  @Timestamp(key: Sidewalk.v0_0_1_Beta.createdAt, on: .create)
  var createdAt: Date?
  
  @Timestamp(key: Sidewalk.v0_0_1_Beta.updatedAt, on: .update)
  var updatedAt: Date?
  
  @Timestamp(key: Sidewalk.v0_0_1_Beta.deletedAt, on: .delete)
  var deletedAt: Date?
  
  init(){}
  
  init(id: UUID? = nil,
       pathCoordinates: GeometricLineString2D) {
    self.id = id
    self.pathCoordinates = pathCoordinates
  }
}


extension Sidewalk: ResponseConvertable {
  func toResponse() -> SidewalkResponse {
    SidewalkResponse(id: self.id,
                     pathCoordinates: self.pathCoordinates.toCoordinates(),
                     createdAt: self.createdAt,
                     updatedAt: self.updatedAt,
                     deletedAt: self.deletedAt)
  }
}
