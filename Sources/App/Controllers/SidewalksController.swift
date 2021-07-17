//
//  File.swift
//  
//
//  Created by Michael Helmbrecht on 12.07.21.
//

import Vapor
import Fluent
import FluentPostGIS


struct SidewalkResponse: Content {
  let id: UUID?
  let pathCoordinates: [Coordinate]
  let nodesCoordinates: [Coordinate]
}

struct SidewalkRequestData: Content {
  let pathCoordinates: [Coordinate]
  let nodesCoordinates: [Coordinate]
}


struct SidewalksController: RouteCollection{
  func boot(routes: RoutesBuilder) throws {
    routes.group("sidewalks") { builder in
      builder.get(use: index)
      builder.post(use: create)
    }
  }
  
  func index(req: Request) -> EventLoopFuture<[Sidewalk]> {
    Sidewalk.query(on: req.db).all()
  }
  
  func create(req: Request) throws -> EventLoopFuture<HTTPStatus> {
    let sidewalkRequest = try req.content.decode(SidewalkRequestData.self)
    guard sidewalkRequest.pathCoordinates.count >= 2 else { throw APIError.incorrectPointCount }
    let nodesCoordinates: [GeometryCollectable] = sidewalkRequest.pathCoordinates.map{GeographicPoint2D(coordinate: $0)}
    let sidewalk = Sidewalk(pathCoordinates: sidewalkRequest.pathCoordinates, nodesCoordinate: GeographicGeometryCollection2D(geometries: nodesCoordinates))
    return sidewalk
      .save(on: req.db)
      .map{
          .created
//        SidewalkResponse(id: sidewalk.id, pathCoordinates: sidewalk.pathCoordinates, nodesCoordinates: sidewalkRequest.nodesCoordinates)
      }
  }
  
  func searchInRegion(req: Request) -> EventLoopFuture<Void> {
    
    req.eventLoop.future()
  }
  
}
