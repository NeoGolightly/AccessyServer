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
    let nodesGroup = routes.grouped("nodes")
    nodesGroup.get(use: index)
  }
  
  
  func index(_ req: Request) -> EventLoopFuture<[NodeResponse]>{
    Node.query(on: req.db).with(\.$roadSegments).all().mapEach{$0.toResponse()}
  }
}
