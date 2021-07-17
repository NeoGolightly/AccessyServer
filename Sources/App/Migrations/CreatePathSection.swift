//
//  File.swift
//  
//
//  Created by Michael Helmbrecht on 07.07.21.
//

import Fluent


struct CreatePathSection: Migration {
  func prepare(on database: Database) -> EventLoopFuture<Void> {
    database.schema(PathSection.v0_0_1_Beta.schema)
      .id()
      .field(PathSection.v0_0_1_Beta.pathCoordinates, .array(of: .json), .required)
      .field(PathSection.v0_0_1_Beta.createdAt, .datetime)
      .field(PathSection.v0_0_1_Beta.updatedAt, .datetime)
      .field(PathSection.v0_0_1_Beta.deletedAt, .datetime)
      .create()
  }
  
  func revert(on database: Database) -> EventLoopFuture<Void> {
    database.schema(PathSection.v0_0_1_Beta.schema).delete()
  }
}



extension PathSection {
  enum v0_0_1_Beta {
    static let schema: String = "path_section"
    static let id = FieldKey(stringLiteral: "id")
    static let pathCoordinates = FieldKey(stringLiteral: "path_coordinates")
    static let createdAt = FieldKey(stringLiteral: "created_at")
    static let updatedAt = FieldKey(stringLiteral: "updated_at")
    static let deletedAt = FieldKey(stringLiteral: "deleted_at")
  }
}
