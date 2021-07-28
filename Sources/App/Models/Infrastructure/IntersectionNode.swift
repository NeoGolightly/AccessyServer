//
//  File.swift
//  
//
//  Created by Michael Helmbrecht on 07.07.21.
//

import Vapor
import Fluent
import FluentPostGIS
import WKCodable

protocol ResponseConvertable {
  associatedtype ResponseType
  func toResponse() -> ResponseType
}


extension IntersectionNode: Content {}

final class IntersectionNode: Model, DateRepresentable {
  static let schema: String = IntersectionNode.v0_0_1_Beta.schema
  
  @ID(key: .id)
  var id: UUID?
  
  @Field(key: IntersectionNode.v0_0_1_Beta.coordiante)
  var coordinate: GeometricPoint2D
  
  @Field(key: IntersectionNode.v0_0_1_Beta.adjacentInfrastructures)
  var adjacentInfrastructures: [String]
  
  @Timestamp(key: IntersectionNode.v0_0_1_Beta.createdAt, on: .create)
  var createdAt: Date?
  
  @Timestamp(key: IntersectionNode.v0_0_1_Beta.updatedAt, on: .update)
  var updatedAt: Date?
  
  @Timestamp(key: IntersectionNode.v0_0_1_Beta.deletedAt, on: .delete)
  var deletedAt: Date?
  
  init(){}
  
  init(id: UUID? = nil, coordinate: GeometricPoint2D, adjacentInfrastructures: [String]) {
    self.id = id
    self.coordinate = coordinate
    self.adjacentInfrastructures = adjacentInfrastructures
  }
}

extension IntersectionNode: ResponseConvertable {
  func toResponse() -> IntersectionNodeResponse {
    IntersectionNodeResponse(id: id,
                             coordinate: Coordinate(geometricPoint2D: coordinate),
                             createdAt: createdAt,
                             updatedAt: updatedAt,
                             deletedAt: deletedAt,
                             adjacentInfrastructures: adjacentInfrastructures)
  }
  

}


