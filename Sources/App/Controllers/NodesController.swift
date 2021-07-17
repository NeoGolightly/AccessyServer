//
//  File.swift
//  
//
//  Created by Michael Helmbrecht on 06.07.21.
//

import Vapor
import Fluent
import FluentPostGIS

struct NodesController: RouteCollection {
  func boot(routes: RoutesBuilder) throws {
    routes.group("pathnodes") { builder in
      builder.get(use: index)
    }
    
    routes.group("pathnodeswithchildren") { builder in
      builder.get(use: indexWithChildren)
    }
    
  }
  
  func index(_ req: Request) -> EventLoopFuture<[PathNodeResponse]>{
    PathNode.query(on: req.db).all().mapEach{$0.toResponseWithoutChildren()}
  }
  
  func indexWithChildren(_ req: Request) -> EventLoopFuture<[PathNodeWithChildrenResponse]>{
    PathNode.query(on: req.db).with(\.$pathSegments).all().mapEach{$0.toResponseWithChildren()}
  }
}

//MARK: Responses
struct PathNodeWithChildrenResponse: Content{
  let id: UUID?
  let coordinate: Coordinate
  let pathSections: [PathSectionResponse]
  let createdAt: Date?
  let updatedAt: Date?
  let deletedAt: Date?
  
  init(id: UUID?, coordinate: Coordinate, pathSections: [PathSectionResponse], createdAt: Date?, updatedAt: Date?, deletedAt: Date?) {
    self.id = id
    self.coordinate = coordinate
    self.pathSections = pathSections
    self.createdAt = createdAt
    self.updatedAt = updatedAt
    self.deletedAt = deletedAt
  }
}
struct PathSectionResponse: Content {
  let id: UUID?
  let pathCoordinates: [Coordinate]
  let createdAt: Date?
  let updatedAt: Date?
  let deletedAt: Date?
  
  init(id: UUID?, pathCoordinates: [Coordinate], createdAt: Date?, updatedAt: Date?, deletedAt: Date?) {
    self.id = id
    self.pathCoordinates = pathCoordinates
    self.createdAt = createdAt
    self.updatedAt = updatedAt
    self.deletedAt = deletedAt
  }
}

//MARK: Model Extensions
extension PathSection {
  func toResponseWithoutChildren() -> PathSectionResponse {
    PathSectionResponse(id: self.id,
                        pathCoordinates: self.pathCoordinates,
                        createdAt: self.createdAt,
                        updatedAt: self.updatedAt,
                        deletedAt: self.deletedAt)
  }
}

extension PathNode {
  func toResponseWithChildren() -> PathNodeWithChildrenResponse{
    PathNodeWithChildrenResponse(id: self.id,
                             coordinate: Coordinate(latitude: self.coordinate.latitude, longitude: self.coordinate.longitude),
                             pathSections: self.pathSegments.map{$0.toResponseWithoutChildren()},
                             createdAt: self.createdAt,
                             updatedAt: self.updatedAt,
                             deletedAt: self.deletedAt)
  }
}
