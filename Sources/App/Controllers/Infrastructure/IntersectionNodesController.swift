//
//  File.swift
//  
//
//  Created by Michael Helmbrecht on 06.07.21.
//

import Vapor
import Fluent
import FluentPostGIS

struct IntersectionNodesController: RouteCollection {
  func boot(routes: RoutesBuilder) throws {
    routes.group("intersectionnodes") { builder in
      builder.get(use: getAllHandler)
    }
  }
  
  func getAllHandler(_ req: Request) -> EventLoopFuture<[IntersectionNodeResponse]>{
    IntersectionNode.query(on: req.db).all().mapEach{ $0.toResponse() }
  }
}
