//
//  File.swift
//  
//
//  Created by Michael Helmbrecht on 12.07.21.
//

import Vapor
import Fluent
import FluentPostGIS

struct InfrastructureResponse: Content {
  let sidewalks: [SidewalkResponse]
}

struct CoordinateRegion: Codable{
  let coordinate: Coordinate
  let radius: Double
}




struct InfrastructureController: RouteCollection {
  func boot(routes: RoutesBuilder) throws {
    routes.group("infrastructure") { builder in
      builder.get("region", use: searchInRegion)
    }
  }
  
  func searchInRegion(req: Request) throws -> EventLoopFuture<InfrastructureResponse> {
    print(req.query)
    guard let latitude = req.query[Double.self, at: "latitude"],
          let longitude = req.query[Double.self, at: "longitude"],
          let radius = req.query[Double.self, at: "radius"]
    else { throw Abort(.badRequest) }
    let gisCoordinate = GeographicPoint2D(longitude: longitude, latitude: latitude)
    let sidewalkSearch = Sidewalk.query(on: req.db).filterGeometryDistanceWithin(\.$nodesCoordinate, gisCoordinate, radius).all()
    return sidewalkSearch
      .mapEach{
        SidewalkResponse(id: $0.id,
                         pathCoordinates: $0.pathCoordinates,
                         nodesCoordinates: $0.nodesCoordinate.allPoint2D.map{ Coordinate(geographicPoint2D: $0)})
      }
      .map{
        InfrastructureResponse(sidewalks: $0)
      }
          
  }
}

