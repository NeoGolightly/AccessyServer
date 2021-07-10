//
//  File.swift
//  
//
//  Created by Michael Helmbrecht on 07.07.21.
//

import Fluent
import FluentPostGIS

struct CreateNode: Migration {
  func prepare(on database: Database) -> EventLoopFuture<Void> {
    database.schema(Node.v0_0_1_Beta.schema)
      .id()
      .field(Node.v0_0_1_Beta.coordiante, GeographicPoint2D.dataType, .required)
      .field(Node.v0_0_1_Beta.createdAt, .datetime)
      .field(Node.v0_0_1_Beta.updatedAt, .datetime)
      .field(Node.v0_0_1_Beta.deletedAt, .datetime)
      .unique(on: Node.v0_0_1_Beta.coordiante, name: "node already exists and should be unique")
      .create()
  }
  
  func revert(on database: Database) -> EventLoopFuture<Void> {
    database.schema(Node.v0_0_1_Beta.schema).delete()
  }
}

extension Node {
  enum v0_0_1_Beta {
    static let schema: String = "nodes"
    static let id = FieldKey(stringLiteral: "id")
    static let coordiante = FieldKey(stringLiteral: "coordinate")
    static let createdAt = FieldKey(stringLiteral: "created_at")
    static let updatedAt = FieldKey(stringLiteral: "updated_at")
    static let deletedAt = FieldKey(stringLiteral: "deleted_at")
  }
}
