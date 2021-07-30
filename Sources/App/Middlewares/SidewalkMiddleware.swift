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

struct SidewalkMiddleware: ModelMiddleware {
  func create(model: SidewalkDBModel, on db: Database, next: AnyModelResponder) -> EventLoopFuture<Void> {
    checkPointCount(model: model, db: db)
      .flatMap{ checkFirstAndLastCoordinateNotEqual(model: model, db: db) }
      .flatMap{ checkIfSidewalkAlreadyExists(model: model, db: db) }
      .flatMap{ next.create(model, on: db) }
  }
  
  func update(model: SidewalkDBModel, on db: Database, next: AnyModelResponder) -> EventLoopFuture<Void> {
    checkPointCount(model: model, db: db)
      .flatMap{ checkFirstAndLastCoordinateNotEqual(model: model, db: db) }
      .flatMap{next.update(model, on: db)}
    
  }
  
  private func checkPointCount(model: SidewalkDBModel, db: Database) -> EventLoopFuture<Void> {
    guard model.pathCoordinates.points.count >= 2 else {
      return db.eventLoop.future(error: APIError.incorrectPointCount)
    }
    return db.eventLoop.makeSucceededVoidFuture()
  }
  
  private func checkFirstAndLastCoordinateNotEqual(model: SidewalkDBModel, db: Database) -> EventLoopFuture<Void> {
    guard model.pathCoordinates.points.first != model.pathCoordinates.points.last else {
      return db.eventLoop.future(error: APIError.firstAndLastPointCanNotBeEqual)
    }
    return db.eventLoop.makeSucceededVoidFuture()
  }
  
  
  private func checkIfSidewalkAlreadyExists(model: SidewalkDBModel, db: Database) -> EventLoopFuture<Void> {
    return SidewalkDBModel.query(on: db).filterGeometryEquals(\.$pathCoordinates, model.pathCoordinates)
      .all()
      .guard({ $0.isEmpty }, else: APIError.sidewalkAlreadyExists)
              .transform(to: db.eventLoop.makeSucceededVoidFuture())
  }
  
}
