//
//  File.swift
//  
//
//  Created by Michael Helmbrecht on 12.07.21.
//

import Vapor
import Fluent
import FluentPostGIS


struct SidewalksController: RouteCollection{
  func boot(routes: RoutesBuilder) throws {
    routes.group("sidewalks") { builder in
      builder.get(use: getAllHandler)
      builder.post(use: createHandler)
      builder.delete(":sidewalkID", use: deleteHandler)
    }
  }
  
  func getAllHandler(req: Request) -> EventLoopFuture<[SidewalkResponse]> {
    Sidewalk.query(on: req.db).all()
      .mapEach{
        SidewalkResponse(id: $0.id,
                         pathCoordinates: $0.pathCoordinates.toCoordinates(),
                         createdAt: $0.createdAt,
                         updatedAt: $0.updatedAt,
                         deletedAt: $0.deletedAt)
    }
  }
  
  
  
  func createHandler(req: Request) throws -> EventLoopFuture<SidewalkResponse> {
    let sidewalkRequest = try req.content.decode(SidewalkRequestData.self)
    guard let nodeACoordinate = sidewalkRequest.pathCoordinates.first,
          let nodeBCoordinate = sidewalkRequest.pathCoordinates.last
    else { return req.eventLoop.future(error: Abort(.badRequest) ) }
    
    let sidewalk = Sidewalk(pathCoordinates: GeometricLineString2D(coordinates: sidewalkRequest.pathCoordinates))
//    let intersectionNodeA = IntersectionNode(coordinate: GeometricPoint2D(coordinate: nodeACoordinate))
//    let intersectionNodeB = IntersectionNode(coordinate: GeometricPoint2D(coordinate: nodeBCoordinate))
    return req.db.transaction { database in
      return sidewalk.save(on: database)
        
    }
    .transform(to: sidewalk.toResponse())
  }
  
  func saveOrAppendIntersectionNodes(database: Database, nodeACoordinate: GeometricPoint2D, nodeBCoordinate: GeometricPoint2D){
    //
//    let nodeAQuery = IntersectionNode.query(on: database).filterGeometryEquals(\.$coordinate, nodeACoordinate).count()
//    let nodeBQuery = IntersectionNode.query(on: database).filterGeometryEquals(\.$coordinate, nodeBCoordinate).count()
//    let nodesQuery = [nodeAQuery, nodeBQuery]
//    return nodesQuery.flatten(on: database.eventLoop).flatMapEach(on: database) { queryResult in
//      guard queryResult <= 1 else { return Abort(.badRequest) }
//
//    }
  }
  
  func deleteHandler(req: Request) -> EventLoopFuture<HTTPStatus> {
    Sidewalk.find(req.parameters.get("sidewalkID"), on: req.db)
      .unwrap(or: Abort(.notFound))
      .flatMap{ sidewalk in
        sidewalk.delete(on: req.db)
          .transform(to: .noContent)
      }
  }
  
}
