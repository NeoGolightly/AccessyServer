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
import Darwin


struct SegmentsController: RouteCollection {
  func boot(routes: RoutesBuilder) throws {
    let segmentsGroup = routes.grouped("segments")
    segmentsGroup.get(use: index)
    segmentsGroup.post(use: create)
  }
  
  
  func index(_ req: Request) -> EventLoopFuture<[RoadSegmentResponse]>{
    RoadSegment.query(on: req.db).with(\.$nodes).all().mapEach{$0.toResponse()}
  }
  
  
  
  func create(req: Request) throws -> EventLoopFuture<RoadSegmentResponse> {
    let roadSegmentData = try req.content.decode(CreateRoadSegmentData.self)
    guard roadSegmentData.points.count == 2 else {
      return req.eventLoop.future(error: Abort(.badRequest, reason: "'points' count should be equal or greater than 2"))
    }
    guard let coordinateA = roadSegmentData.points.first,
          let coordinateB = roadSegmentData.points.last, coordinateA != coordinateB
    else {
      return req.eventLoop.future(error: Abort(.badRequest, reason: "first and last coordinate are equal"))
    }
    
    let nodes = Node.query(on: req.db)
      .filterGeometryDistanceWithin(\.$coordiante, GeographicPoint2D(longitude: coordinateA.longitude, latitude: coordinateA.latitude), 1)
      .all()
    
    let nodeA = Node(coordinate: GeographicPoint2D(longitude: coordinateA.longitude, latitude: coordinateA.latitude))
    let nodeB = Node(coordinate: GeographicPoint2D(longitude: coordinateB.longitude, latitude: coordinateB.latitude))
    let roadSegment = RoadSegment(points: roadSegmentData.points)
    return
//    nodes.guard({ nodes in
//      nodes.isEmpty
//    } ,else: Abort(.badRequest, reason: "Corrdinate for Node: \(coordinateA.longitude), \(coordinateA.latitude) already exists"))
                        nodeA.save(on: req.db)
                        .and(nodeB.save(on: req.db))
                        .and(roadSegment.save(on: req.db))
                        .flatMap{ _ in
                          roadSegment.$nodes.attach([nodeA, nodeB], on: req.db)
                        }
                        .flatMap{_ in
                          roadSegment.$nodes.load(on: req.db)
                        }
                        .map{_ in
          
                          return RoadSegment.find(roadSegment.id, on: req.db).map{$0?.toResponse()}.unwrap(or: Abort(.notFound))
                          
                        }
  }
  
}


extension GeographicPoint2D: Content{}

extension RoadSegment: Content{}

struct CreateNodeData: Content {
  let id: UUID?
  let coordinate: Coordinate
}

struct CreateRoadSegmentData: Content {
  var points: [Coordinate]
}

struct RoadSegmentResponse: Content{
  let id: UUID?
  let points: [Coordinate]
  let nodes: [NodeResponse]
  let createdAt: Date?
  let updatedAt: Date?
  let deletedAt: Date?
}

extension RoadSegment{
  func toResponse() -> RoadSegmentResponse {
    return RoadSegmentResponse(id: self.id,
                               points: self.points,
                               nodes: self.nodes.map{$0.toResponse()},
                               createdAt: self.createdAt,
                               updatedAt: self.updatedAt,
                               deletedAt: self.deletedAt)
    
  }
}

extension Node {
  func toResponse() -> NodeResponse {
    NodeResponse(id: self.id,
                 coordinate: Coordinate(latitude: self.coordiante.latitude,
                                        longitude: self.coordiante.longitude),
                 roadSegments: self.roadSegments.map{$0.toResponse()},
                 createdAt: self.createdAt,
                 updatedAt: self.updatedtAt,
                 deletedAt: self.deletedAt)
  }
}

struct NodeResponse: Content{
  let id: UUID?
  let coordinate: Coordinate
  let roadSegments: [RoadSegmentResponse]
  let createdAt: Date?
  let updatedAt: Date?
  let deletedAt: Date?
}
