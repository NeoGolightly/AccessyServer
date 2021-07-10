//
//  File.swift
//  
//
//  Created by Michael Helmbrecht on 06.07.21.
//

import Fluent
import FluentPostGIS

struct CreateLocationTest: Migration {
  func prepare(on database: Database) -> EventLoopFuture<Void> {
    return database.schema(LocationTest.schema)
//      .field("id", .int, .identifier(auto: true))
      .id()
      .field("location", GeographicPoint2D.dataType)
      .create()
  }
  
  func revert(on database: Database) -> EventLoopFuture<Void> {
    return database.schema(LocationTest.schema).delete()
  }
}
