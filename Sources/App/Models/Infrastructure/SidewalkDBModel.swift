//
//  File.swift
//  
//
//  Created by Michael Helmbrecht on 13.07.21.
//

import Vapor
import Fluent
import FluentPostGIS


extension SidewalkDBModel: Content {}

final class SidewalkDBModel: Model, InfrastructureType {
  static var schema: String = SidewalkDBModel.v0_0_1_Beta.schema
  
  @ID(key: .id)
  var id: UUID?
  
  @Field(key: SidewalkDBModel.v0_0_1_Beta.pathCoordinates)
  var pathCoordinates: GeometricLineString2D
  
  @Timestamp(key: SidewalkDBModel.v0_0_1_Beta.createdAt, on: .create)
  var createdAt: Date?
  
  @Timestamp(key: SidewalkDBModel.v0_0_1_Beta.updatedAt, on: .update)
  var updatedAt: Date?
  
  @Timestamp(key: SidewalkDBModel.v0_0_1_Beta.deletedAt, on: .delete)
  var deletedAt: Date?
  
  init(){}
  
  init(id: UUID? = nil,
       pathCoordinates: GeometricLineString2D) {
    self.id = id
    self.pathCoordinates = pathCoordinates
  }
}


extension SidewalkDBModel: ResponseConvertable {
  func toResponse() -> Sidewalk {
    Sidewalk(id: self.id,
             pathCoordinates: self.pathCoordinates.toCoordinates(),
             createdAt: self.createdAt,
             updatedAt: self.updatedAt,
             deletedAt: self.deletedAt)
  }
}
