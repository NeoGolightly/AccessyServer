//
//  File.swift
//  
//
//  Created by Michael Helmbrecht on 07.07.21.
//

import Fluent

struct CreateNodeRoadSegmentPivot: Migration {

  func prepare(on database: Database) -> EventLoopFuture<Void> {
    database.schema(NodeRoadSegmentPivot.v0_0_1_Beta.schema)
      .id()
      .field(NodeRoadSegmentPivot.v0_0_1_Beta.nodeID, .uuid, .required, .references(Node.v0_0_1_Beta.schema, Node.v0_0_1_Beta.id, onDelete: .cascade))
      .field(NodeRoadSegmentPivot.v0_0_1_Beta.roadSegmentID, .uuid, .required, .references(RoadSegment.v0_0_1_Beta.schema, RoadSegment.v0_0_1_Beta.id, onDelete: .cascade))
      .unique(on: NodeRoadSegmentPivot.v0_0_1_Beta.nodeID, NodeRoadSegmentPivot.v0_0_1_Beta.roadSegmentID)
      .create()
  }
  
  func revert(on database: Database) -> EventLoopFuture<Void> {
    database.schema(NodeRoadSegmentPivot.v0_0_1_Beta.schema).delete()
  }
  
}

extension NodeRoadSegmentPivot {
  enum v0_0_1_Beta {
    static let schema: String = "node_road_segment_pivot"
    static let id = FieldKey(stringLiteral: "id")
    static let nodeID = FieldKey(stringLiteral: "node_id")
    static let roadSegmentID = FieldKey(stringLiteral: "road_segment_id")
  }
}
