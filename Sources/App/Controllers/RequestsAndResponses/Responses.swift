//
//  File.swift
//  File
//
//  Created by Michael Helmbrecht on 25.07.21.
//

import Vapor

struct InfrastructureResponse: Content {
  let sidewalks: [SidewalkResponse]
  let intersectionNodes: [IntersectionNodeResponse]
}


struct SidewalkResponse: Content, DateRepresentable {
  let id: UUID?
  let pathCoordinates: [Coordinate]
  let createdAt: Date?
  let updatedAt: Date?
  let deletedAt: Date?
}

struct IntersectionNodeResponse: Content, DateRepresentable, AdjacentInfrastructuresRepresentable {
  let id: UUID?
  let coordinate: Coordinate
  let createdAt: Date?
  let updatedAt: Date?
  let deletedAt: Date?
  let adjacentInfrastructures: [String]
}
