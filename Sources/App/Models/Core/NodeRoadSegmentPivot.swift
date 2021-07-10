//
//  File.swift
//  
//
//  Created by Michael Helmbrecht on 07.07.21.
//

import Foundation
import FluentKit


final class NodeRoadSegmentPivot: Model {
  static let schema: String = NodeRoadSegmentPivot.v0_0_1_Beta.schema
  
  @ID
  var id: UUID?
  
  @Parent(key: NodeRoadSegmentPivot.v0_0_1_Beta.nodeID)
  var node: Node
  
  @Parent(key: NodeRoadSegmentPivot.v0_0_1_Beta.roadSegmentID)
  var roadSegment: RoadSegment
  
  init() {}
  init(id: UUID? = nil, node: Node, roadSegment: RoadSegment) throws {
    self.id = id
    self.$node.id = try node.requireID()
    self.$roadSegment.id = try roadSegment.requireID()
  }
  
}
