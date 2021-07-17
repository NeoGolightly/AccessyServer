//
//  File.swift
//  
//
//  Created by Michael Helmbrecht on 07.07.21.
//

import Foundation
import FluentKit


final class PathNodePathSectionPivot: Model {
  static let schema: String = PathNodePathSectionPivot.v0_0_1_Beta.schema
  
  @ID
  var id: UUID?
  
  @Parent(key: PathNodePathSectionPivot.v0_0_1_Beta.pathNodeID)
  var pathNode: PathNode
  
  @Parent(key: PathNodePathSectionPivot.v0_0_1_Beta.pathSectionID)
  var roadSegment: PathSection
  
  init() {}
  init(id: UUID? = nil, pathNode: PathNode, pathSection: PathSection) throws {
    self.id = id
    self.$pathNode.id = try pathNode.requireID()
    self.$roadSegment.id = try pathSection.requireID()
  }
  
}
