//
//  File.swift
//  
//
//  Created by Michael Helmbrecht on 07.07.21.
//

import Fluent


struct CreateRoadSegment: Migration {
  func prepare(on database: Database) -> EventLoopFuture<Void> {
    database.schema(RoadSegment.v0_0_1_Beta.schema)
      .id()
      .field(RoadSegment.v0_0_1_Beta.points, .array(of: .json), .required)
      .field(RoadSegment.v0_0_1_Beta.createdAt, .datetime)
      .field(RoadSegment.v0_0_1_Beta.updatedAt, .datetime)
      .field(RoadSegment.v0_0_1_Beta.deletedAt, .datetime)
      .create()
  }
  
  func revert(on database: Database) -> EventLoopFuture<Void> {
    database.schema(RoadSegment.v0_0_1_Beta.schema).delete()
  }
}



extension RoadSegment {
  enum v0_0_1_Beta {
    static let schema: String = "road_segment"
    static let id = FieldKey(stringLiteral: "id")
    static let points = FieldKey(stringLiteral: "points")
    static let createdAt = FieldKey(stringLiteral: "created_at")
    static let updatedAt = FieldKey(stringLiteral: "updated_at")
    static let deletedAt = FieldKey(stringLiteral: "deleted_at")
  }
}
