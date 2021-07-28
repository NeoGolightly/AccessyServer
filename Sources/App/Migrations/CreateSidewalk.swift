//
//  File.swift
//  
//
//  Created by Michael Helmbrecht on 07.07.21.
//

import Fluent
import FluentPostGIS


struct CreateSidewalk: Migration {
  func prepare(on database: Database) -> EventLoopFuture<Void> {
    database.schema(Sidewalk.v0_0_1_Beta.schema)
      .id()
      .field(Sidewalk.v0_0_1_Beta.pathCoordinates, GeometricLineString2D.dataType, .required)
//      .field(Sidewalk.v0_0_1_Beta.nodesCoordinates, GeographicGeometryCollection2D.dataType, .required)
      .field(Sidewalk.v0_0_1_Beta.createdAt, .datetime)
      .field(Sidewalk.v0_0_1_Beta.updatedAt, .datetime)
      .field(Sidewalk.v0_0_1_Beta.deletedAt, .datetime)
      .create()
  }
  
  func revert(on database: Database) -> EventLoopFuture<Void> {
    database.schema(Sidewalk.v0_0_1_Beta.schema).delete()
  }
}



extension Sidewalk {
  enum v0_0_1_Beta {
    static let schema: String = "sidewalk"
    static let id = FieldKey(stringLiteral: "id")
    static let pathCoordinates = FieldKey(stringLiteral: "path_coordinates")
//    static let nodesCoordinates = FieldKey(stringLiteral: "nodes_coordinates")
    static let createdAt = FieldKey(stringLiteral: "created_at")
    static let updatedAt = FieldKey(stringLiteral: "updated_at")
    static let deletedAt = FieldKey(stringLiteral: "deleted_at")
  }
}
