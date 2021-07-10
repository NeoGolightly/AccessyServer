//
//  File.swift
//  
//
//  Created by Michael Helmbrecht on 07.07.21.
//

import Vapor
import Fluent
import Foundation

final class RoadSegment: Model {
  static var schema: String = RoadSegment.v0_0_1_Beta.schema
  
  @ID(key: .id)
  var id: UUID?
  
  @Field(key: RoadSegment.v0_0_1_Beta.points)
  var points: [Coordinate]
  
  @Siblings(through: NodeRoadSegmentPivot.self, from: \.$roadSegment, to: \.$node)
  public var nodes: [Node]
  
  @Timestamp(key: RoadSegment.v0_0_1_Beta.createdAt, on: .create)
  var createdAt: Date?
  
  @Timestamp(key: RoadSegment.v0_0_1_Beta.updatedAt, on: .update)
  var updatedAt: Date?
  
  @Timestamp(key: RoadSegment.v0_0_1_Beta.deletedAt, on: .delete)
  var deletedAt: Date?
  
  init(){}
  
  init(id: UUID? = nil,
       points: [Coordinate] = []) {
    self.id = id
    self.points = points
  }
}

