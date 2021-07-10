//
//  File.swift
//  
//
//  Created by Michael Helmbrecht on 07.07.21.
//

import Vapor
import Fluent
import FluentPostGIS
import WKCodable


final class Node: Model {
  static let schema: String = Node.v0_0_1_Beta.schema
  
  @ID(key: .id)
  var id: UUID?
  
  @Field(key: Node.v0_0_1_Beta.coordiante)
  var coordiante: GeographicPoint2D
  
  @Siblings(through: NodeRoadSegmentPivot.self, from: \.$node, to: \.$roadSegment)
  public var roadSegments: [RoadSegment]
  
  @Timestamp(key: Node.v0_0_1_Beta.createdAt, on: .create)
  var createdAt: Date?
  
  @Timestamp(key: Node.v0_0_1_Beta.updatedAt, on: .update)
  var updatedtAt: Date?
  
  @Timestamp(key: Node.v0_0_1_Beta.deletedAt, on: .delete)
  var deletedAt: Date?
  
  init(){}
  
  init(id: UUID? = nil, coordinate: GeographicPoint2D) {
    self.id = id
    self.coordiante = coordinate
  }
}


//extension WKCodable.Point {
//  public var longitude: Double { return vector[0] }
//  public var latitude: Double { return vector[1] }
//}


