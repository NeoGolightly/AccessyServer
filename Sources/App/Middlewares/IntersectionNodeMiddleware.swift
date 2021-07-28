//
//  File.swift
//  File
//
//  Created by Michael Helmbrecht on 17.07.21.
//

import Vapor
import Fluent
import WKCodable
import FluentPostGIS

struct IntersectionNodeMiddleware: ModelMiddleware {
  func create(model: IntersectionNode, on db: Database, next: AnyModelResponder) -> EventLoopFuture<Void> {
    checkIfInteractionNodeAlreadyExists(model: model, db: db)
      .flatMap{ next.create(model, on: db) }
  }
    
  private func checkIfInteractionNodeAlreadyExists(model: IntersectionNode, db: Database) -> EventLoopFuture<Void> {
    return IntersectionNode.query(on: db).filterGeometryEquals(\.$coordinate, model.coordinate)
      .all()
      .guard({ $0.isEmpty }, else: APIError.intersectionNodeAlreadyExists)
              .transform(to: db.eventLoop.makeSucceededVoidFuture())
  }
  
}
