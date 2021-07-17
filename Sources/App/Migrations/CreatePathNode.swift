//
//  File.swift
//  
//
//  Created by Michael Helmbrecht on 07.07.21.
//

import Fluent
import FluentPostGIS

struct CreatePathNode: Migration {
  func prepare(on database: Database) -> EventLoopFuture<Void> {
    database.schema(PathNode.v0_0_1_Beta.schema)
      .id()
      .field(PathNode.v0_0_1_Beta.coordiante, GeographicPoint2D.dataType, .required)
      .field(PathNode.v0_0_1_Beta.createdAt, .datetime)
      .field(PathNode.v0_0_1_Beta.updatedAt, .datetime)
      .field(PathNode.v0_0_1_Beta.deletedAt, .datetime)
      .unique(on: PathNode.v0_0_1_Beta.coordiante, name: "PathNode already exists and should be unique")
      .create()
  }
  
  func revert(on database: Database) -> EventLoopFuture<Void> {
    database.schema(PathNode.v0_0_1_Beta.schema).delete()
  }
}

extension PathNode {
  enum v0_0_1_Beta {
    static let schema: String = "path_nodes"
    static let id = FieldKey(stringLiteral: "id")
    static let coordiante = FieldKey(stringLiteral: "coordinate")
    static let createdAt = FieldKey(stringLiteral: "created_at")
    static let updatedAt = FieldKey(stringLiteral: "updated_at")
    static let deletedAt = FieldKey(stringLiteral: "deleted_at")
  }
}
