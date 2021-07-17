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


final class PathNode: Model {
  static let schema: String = PathNode.v0_0_1_Beta.schema
  
  @ID(key: .id)
  var id: UUID?
  
  @Field(key: PathNode.v0_0_1_Beta.coordiante)
  var coordinate: GeographicPoint2D
  
  @Siblings(through: PathNodePathSectionPivot.self, from: \.$pathNode, to: \.$roadSegment)
  public var pathSegments: [PathSection]
  
  @Timestamp(key: PathNode.v0_0_1_Beta.createdAt, on: .create)
  var createdAt: Date?
  
  @Timestamp(key: PathNode.v0_0_1_Beta.updatedAt, on: .update)
  var updatedAt: Date?
  
  @Timestamp(key: PathNode.v0_0_1_Beta.deletedAt, on: .delete)
  var deletedAt: Date?
  
  init(){}
  
  init(id: UUID? = nil, coordinate: GeographicPoint2D) {
    self.id = id
    self.coordinate = coordinate
  }
}


