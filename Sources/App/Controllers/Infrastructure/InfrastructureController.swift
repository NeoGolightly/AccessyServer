//
//  File.swift
//  
//
//  Created by Michael Helmbrecht on 12.07.21.
//

import Vapor
import Fluent
import FluentPostGIS


extension Infrastructure: Content {}

struct InfrastructureController: RouteCollection {
  func boot(routes: RoutesBuilder) throws {
    routes.group("infrastructure") { builder in
      builder.get(use: getAllHandler)
      builder.get("withCenterCoordinate", use: getAllWithCenterCoordinateHandler)
    }
  }
  
  func getAllHandler(req: Request) throws -> EventLoopFuture<Infrastructure> {
    let sidewalks = SidewalkDBModel.query(on: req.db).all()
    let intersectionNodes = IntersectionNodeDBModel.query(on: req.db).all()
    
    return sidewalks.mapEach{ $0.toResponse() }
      .and(intersectionNodes.mapEach{ $0.toResponse() })
      .map{
        Infrastructure(sidewalks: $0,
                       trafficLights: [],
                       trafficIsland: [],
                       zebraCrossing: [],
                       pedestrianCrossing: [],
                       intersectionNodes: $1)
      }
  }
  
  func getAllWithCenterCoordinateHandler(req: Request) throws -> EventLoopFuture<Infrastructure> {
    print(req.content)
    ///Decode request to CoordinateRegion
    let coordinateWithRadius = try req.query.decode(CenterCoordinateRequestData.self)
    ///Create GeographicPoint2D for querying all infrastructure objects (Sidewalks, TraffikLight …)
    let centerCoodinate = GeographicPoint2D(longitude: coordinateWithRadius.longitude, latitude: coordinateWithRadius.latitude)
    ///Search for all sidewalks from center coordinate (gisCoordinate) with radius
    let sidewalkSearch = SidewalkDBModel.query(on: req.db).filterGeometryDistanceWithin(\.$pathCoordinates, centerCoodinate, coordinateWithRadius.radius).all()
    let intersectionNodesSearch = IntersectionNodeDBModel.query(on: req.db).filterGeometryDistanceWithin(\.$coordinate, centerCoodinate, coordinateWithRadius.radius).all()
    return sidewalkSearch.mapEach{ $0.toResponse() }
    .and(intersectionNodesSearch.mapEach{ $0.toResponse() })
    .map{
      Infrastructure(sidewalks: $0,
                     trafficLights: [],
                     trafficIsland: [],
                     zebraCrossing: [],
                     pedestrianCrossing: [],
                     intersectionNodes: $1)
    }
  }
}

