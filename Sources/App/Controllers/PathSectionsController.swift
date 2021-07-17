//
//  File.swift
//  
//
//  Created by Michael Helmbrecht on 06.07.21.
//

import Vapor
import Fluent
import FluentPostGIS
import WKCodable




struct PathSectionsController: RouteCollection {
  func boot(routes: RoutesBuilder) throws {
    let segmentsGroup = routes.grouped("pathsections")
    segmentsGroup.get(use: index)
    segmentsGroup.post(use: create)
  }
  
  
  func index(_ req: Request) -> EventLoopFuture<[PathSectionWithChildrenResponse]>{
    //Return PathSegment with nodes
    PathSection.query(on: req.db).with(\.$pathNodes).all().mapEach{
      
      let nodes = $0.pathNodes.map{PathNodeResponse(id: $0.id,
                                            coordinate: Coordinate(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude),
                                            createdAt: $0.createdAt,
                                            updatedAt: $0.updatedAt,
                                            deletedAt: $0.deletedAt)}
      return PathSectionWithChildrenResponse(id: $0.id, pathCoordinates: $0.pathCoordinates, pathNodes: nodes, createdAt: $0.createdAt, updatedAt: $0.updatedAt, deletedAt: $0.deletedAt)
    }
  }
  
  

  func create(req: Request) throws -> EventLoopFuture<PathSectionWithChildrenResponse> {
    
    //1. decode request (with CreatePathSegmentData.afterDecode check if point count is correct)
    let pathSegmentData = try req.content.decode(CreatePathSectionData.self)
    //2. check if nodes already exist and throw error if they don't exist but uuid is incorrect
    //3. create nodes if they don't exist and save them
    let nodes = pathSegmentData.pathNodes.map{PathNode(id: $0.id, coordinate: GeographicPoint2D(longitude: $0.coordinate.longitude, latitude: $0.coordinate.latitude))}
    let saveNodes = nodes.map{$0.save(on: req.db)}
    //4. create and save PathSegment
    let pathSegment = PathSection(pathCoordinates: pathSegmentData.pathCoordinates)
    let savePathSegment = pathSegment.save(on: req.db)
    //5. Return
    return saveNodes
      .flatten(on: req.eventLoop)
      .and(savePathSegment)
//      .flatMap{_ -> EventLoopFuture<Void> in
//        //6. attach nodes
//        let attach = nodes.map{ node in pathSegment.$nodes.attach(node, method: .ifNotExists, on: req.db)}
//        return attach.flatten(on: req.eventLoop)
//      }
      .flatMap{_ in
        //6. eager load nodes
        pathSegment.$pathNodes.load(on: req.db)
      }
      .map{ _ in
        //7. return PathSegmentResponse with children
        pathSegment.toResponseWithChildren()
      }
  }
}

//MARK: Create Data
struct CreatePathNodeData: Content {
  let id: UUID?
  let coordinate: Coordinate
}

struct CreatePathSectionData: Content {
  let pathCoordinates: [Coordinate]
  let pathNodes: [CreatePathNodeData]
  func afterDecode() throws {
    if pathCoordinates.count < 2 {
      throw APIError.incorrectPointCount
    }
    if pathNodes.count != 2 {
      throw APIError.incorrectNodesCount
    }
  }
}

//MARK: Responses
struct PathSectionWithChildrenResponse: Content{
  let id: UUID?
  let pathCoordinates: [Coordinate]
  let pathNodes: [PathNodeResponse]
  let createdAt: Date?
  let updatedAt: Date?
  let deletedAt: Date?
  
  init(id: UUID?, pathCoordinates: [Coordinate], pathNodes: [PathNodeResponse], createdAt: Date?, updatedAt: Date?, deletedAt: Date?) {
    self.id = id
    self.pathCoordinates = pathCoordinates
    self.pathNodes = pathNodes
    self.createdAt = createdAt
    self.updatedAt = updatedAt
    self.deletedAt = deletedAt
  }
}

struct PathNodeResponse: Content{
  let id: UUID?
  let coordinate: Coordinate
  let createdAt: Date?
  let updatedAt: Date?
  let deletedAt: Date?
  
  init(id: UUID?, coordinate: Coordinate, createdAt: Date?, updatedAt: Date?, deletedAt: Date?) {
    self.id = id
    self.coordinate = coordinate
    self.createdAt = createdAt
    self.updatedAt = updatedAt
    self.deletedAt = deletedAt
  }
}

//MARK: Model Extensions

extension PathSection {
  func toResponseWithChildren() -> PathSectionWithChildrenResponse {
    PathSectionWithChildrenResponse(id: self.id,
                                    pathCoordinates: self.pathCoordinates,
                                    pathNodes: self.pathNodes.map{$0.toResponseWithoutChildren()},
                                    createdAt: self.createdAt,
                                    updatedAt: self.updatedAt,
                                    deletedAt: self.deletedAt)
  }
}

extension PathNode {
  func toResponseWithoutChildren() -> PathNodeResponse{
    PathNodeResponse(id: self.id,
                 coordinate: Coordinate(latitude: self.coordinate.latitude, longitude: self.coordinate.longitude),
                 createdAt: self.createdAt,
                 updatedAt: self.updatedAt,
                 deletedAt: self.deletedAt)
  }
}
