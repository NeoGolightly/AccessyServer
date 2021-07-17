//
//  File.swift
//  
//
//  Created by Michael Helmbrecht on 07.07.21.
//

import Fluent

struct CreateNodeRoadSegmentPivot: Migration {

  func prepare(on database: Database) -> EventLoopFuture<Void> {
    database.schema(PathNodePathSectionPivot.v0_0_1_Beta.schema)
      .id()
      .field(PathNodePathSectionPivot.v0_0_1_Beta.pathNodeID,
              .uuid,
              .required,
              .references(PathNode.v0_0_1_Beta.schema, PathNode.v0_0_1_Beta.id, onDelete: .cascade))
      .field(PathNodePathSectionPivot.v0_0_1_Beta.pathSectionID,
              .uuid,
              .required,
              .references(PathSection.v0_0_1_Beta.schema, PathSection.v0_0_1_Beta.id, onDelete: .cascade))
      .unique(on: PathNodePathSectionPivot.v0_0_1_Beta.pathNodeID, PathNodePathSectionPivot.v0_0_1_Beta.pathSectionID)
      .create()
  }
  
  func revert(on database: Database) -> EventLoopFuture<Void> {
    database.schema(PathNodePathSectionPivot.v0_0_1_Beta.schema).delete()
  }
  
}

extension PathNodePathSectionPivot {
  enum v0_0_1_Beta {
    static let schema: String = "path_node_path_section_pivot"
    static let id = FieldKey(stringLiteral: "id")
    static let pathNodeID = FieldKey(stringLiteral: "path_node_id")
    static let pathSectionID = FieldKey(stringLiteral: "path_section_id")
  }
}
