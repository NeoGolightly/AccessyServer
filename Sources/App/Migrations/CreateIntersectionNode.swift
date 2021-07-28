//
//  File.swift
//  
//
//  Created by Michael Helmbrecht on 07.07.21.
//

import Fluent
import FluentPostGIS

struct CreateIntersectionNode: Migration {
  func prepare(on database: Database) -> EventLoopFuture<Void> {
    database.schema(IntersectionNode.v0_0_1_Beta.schema)
      .id()
      .field(IntersectionNode.v0_0_1_Beta.coordiante, GeometricPoint2D.dataType, .required)
      .field(IntersectionNode.v0_0_1_Beta.createdAt, .datetime)
      .field(IntersectionNode.v0_0_1_Beta.updatedAt, .datetime)
      .field(IntersectionNode.v0_0_1_Beta.deletedAt, .datetime)
      .unique(on: IntersectionNode.v0_0_1_Beta.coordiante, name: "Intersection node already exists and should be unique")
      .create()
  }
  
  func revert(on database: Database) -> EventLoopFuture<Void> {
    database.schema(IntersectionNode.v0_0_1_Beta.schema).delete()
  }
}

extension IntersectionNode {
  enum v0_0_1_Beta {
    static let schema: String = "intersection_nodes"
    static let id = FieldKey(stringLiteral: "id")
    static let coordiante = FieldKey(stringLiteral: "coordinate")
    static let adjacentInfrastructures = FieldKey(stringLiteral: "adjacent_infrastructures")
    static let createdAt = FieldKey(stringLiteral: "created_at")
    static let updatedAt = FieldKey(stringLiteral: "updated_at")
    static let deletedAt = FieldKey(stringLiteral: "deleted_at")
  }
}
