//
//  File.swift
//  
//
//  Created by Michael Helmbrecht on 07.07.21.
//

import Vapor
import Fluent
import Foundation


final class PathSection: Model {
  static var schema: String = PathSection.v0_0_1_Beta.schema
  
  @ID(key: .id)
  var id: UUID?
  
  @Field(key: PathSection.v0_0_1_Beta.pathCoordinates)
  var pathCoordinates: [Coordinate]
  
  @Siblings(through: PathNodePathSectionPivot.self, from: \.$roadSegment, to: \.$pathNode)
  public var pathNodes: [PathNode]
  
  @Timestamp(key: PathSection.v0_0_1_Beta.createdAt, on: .create)
  var createdAt: Date?
  
  @Timestamp(key: PathSection.v0_0_1_Beta.updatedAt, on: .update)
  var updatedAt: Date?
  
  @Timestamp(key: PathSection.v0_0_1_Beta.deletedAt, on: .delete)
  var deletedAt: Date?
  
  init(){}
  
  init(id: UUID? = nil,
       pathCoordinates: [Coordinate] = []) {
    self.id = id
    self.pathCoordinates = pathCoordinates
  }
}

