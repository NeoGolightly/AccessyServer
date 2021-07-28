//
//  File.swift
//  
//
//  Created by Michael Helmbrecht on 12.07.21.
//

import Vapor
import Fluent
import FluentPostGIS


struct InfrastructureController: RouteCollection {
  func boot(routes: RoutesBuilder) throws {
    routes.group("infrastructure") { builder in
      builder.get(use: getAllHandler)
      builder.get("region", use: searchInRegionHandler)
    }
  }
  
  func getAllHandler(req: Request) throws -> EventLoopFuture<InfrastructureResponse> {
    let sidewalks = Sidewalk.query(on: req.db).all()
    let intersectionNodes = IntersectionNode.query(on: req.db).all()
    
    return sidewalks.mapEach{ $0.toResponse() }
      .and(intersectionNodes.mapEach{ $0.toResponse() })
      .map{
        InfrastructureResponse(sidewalks: $0, intersectionNodes: $1)
      }
  }
  
  func searchInRegionHandler(req: Request) throws -> EventLoopFuture<InfrastructureResponse> {
    print(req.content)
    ///Decode request to CoordinateRegion
    let coordinateWithRadius = try req.query.decode(CoordinateWithRadiusData.self)
    ///Create GeographicPoint2D for querying all infrastructure objects (Sidewalks, TraffikLight …)
    let centerCoodinate = GeographicPoint2D(longitude: coordinateWithRadius.longitude, latitude: coordinateWithRadius.latitude)
    ///Search for all sidewalks from center coordinate (gisCoordinate) with radius
    let sidewalkSearch = Sidewalk.query(on: req.db).filterGeometryDistanceWithin(\.$pathCoordinates, centerCoodinate, coordinateWithRadius.radius).all()
    let intersectionNodesSearch = IntersectionNode.query(on: req.db).filterGeometryDistanceWithin(\.$coordinate, centerCoodinate, coordinateWithRadius.radius).all()
    return sidewalkSearch.mapEach{ $0.toResponse() }
    .and(intersectionNodesSearch.mapEach{ $0.toResponse() })
    .map{
      InfrastructureResponse(sidewalks: $0, intersectionNodes: $1)
    }
  }
}

