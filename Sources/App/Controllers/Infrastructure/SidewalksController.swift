//
//  File.swift
//  
//
//  Created by Michael Helmbrecht on 12.07.21.
//

import Vapor
import Fluent
import FluentPostGIS

extension Sidewalk: Content {}
extension CreateSidewalkData: Content {}


struct SidewalksController: RouteCollection{
  func boot(routes: RoutesBuilder) throws {
    routes.group("sidewalks") { builder in
      builder.get(use: getAllHandler)
      builder.post(use: createHandler)
      builder.delete(":sidewalkID", use: deleteHandler)
    }
  }
  
  func getAllHandler(req: Request) -> EventLoopFuture<[Sidewalk]> {
    SidewalkDBModel.query(on: req.db).all()
      .mapEach{
        Sidewalk(id: $0.id,
                 pathCoordinates: $0.pathCoordinates.toCoordinates(),
                 createdAt: $0.createdAt,
                 updatedAt: $0.updatedAt,
                 deletedAt: $0.deletedAt)
    }
  }
  
  
  
  func createHandler(req: Request) throws -> EventLoopFuture<CreateSidewalkResponse> {
    let sidewalkRequest = try req.content.decode(CreateSidewalkData.self)
    guard let firstCoordinateInPath = sidewalkRequest.pathCoordinates.first,
          let secondCoordinateInPath = sidewalkRequest.pathCoordinates.last
    else { return req.eventLoop.future(error: Abort(.badRequest) ) }
    
    let sidewalk = SidewalkDBModel(pathCoordinates: GeometricLineString2D(coordinates: sidewalkRequest.pathCoordinates))
    let nodeA = getOrCreateIntersectionNode(database: req.db, nodeCoordinate: GeometricPoint2D(coordinate: firstCoordinateInPath))
    let nodeB = getOrCreateIntersectionNode(database: req.db, nodeCoordinate: GeometricPoint2D(coordinate: secondCoordinateInPath))
    
    return  sidewalk
      .save(on: req.db)
      .flatMap{
        [nodeA, nodeB].flatten(on: req.db.eventLoop)
          .flatMap{ nodes -> EventLoopFuture<[IntersectionNodeDBModel]> in
            //if node has no adjacent infrastructure than it should be a newly created node
            let newNodes = nodes.filter { $0.adjacentInfrastructures.isEmpty }
            //add sidewalk id to nodes
            nodes.forEach{ $0.adjacentInfrastructures.append(sidewalk.id!.uuidString) }
            //save new and updated nodes and return newly created ones
            return nodes.map{ $0.save(on: req.db)}.flatten(on: req.db.eventLoop).map{ newNodes }
          }
      }
      .map({ newNodes in
        let sidewalkResponse = sidewalk.toResponse()
        let newIntersectionNodesResponse = newNodes.map{ $0.toResponse() }
        return CreateSidewalkResponse(createdSidewalk: sidewalkResponse, createdIntersectionNodes: newIntersectionNodesResponse)
      })
      
  }
  
  func getOrCreateIntersectionNode(database: Database, nodeCoordinate: GeometricPoint2D) -> EventLoopFuture<IntersectionNodeDBModel> {
    let nodeSearchQuery = IntersectionNodeDBModel.query(on: database).filterGeometryEquals(\.$coordinate, nodeCoordinate)
//    let nodeGuardCount = nodeSearchQuery.all().guard({ $0.count <= 1 }, else: Abort(.badRequest))
    return nodeSearchQuery.first()
      .unwrap(orReplace: IntersectionNodeDBModel(coordinate: nodeCoordinate, adjacentInfrastructures: []) )
  }
  
  func deleteHandler(req: Request) -> EventLoopFuture<HTTPStatus> {
    SidewalkDBModel.find(req.parameters.get("sidewalkID"), on: req.db)
      .unwrap(or: Abort(.notFound))
      .flatMap{ sidewalk in
        sidewalk.delete(on: req.db)
          .transform(to: .noContent)
      }
  }
  
}
