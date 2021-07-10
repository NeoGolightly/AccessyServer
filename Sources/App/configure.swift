import Fluent
import FluentPostgresDriver
import Vapor
import FluentPostGIS

// configures your application
public func configure(_ app: Application) throws {
  // uncomment to serve files from /Public folder
  // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
  print("post: \(Int(Environment.get("PORT") ?? "nil"))")
  app.http.server.configuration.hostname = Environment.get("HOST_NAME") ?? "0.0.0.0"
  app.http.server.configuration.port = Int(Environment.get("PORT") ?? "8080") ?? 7070
  
  let databaseName: String
  let databasePort: Int
  // 1
  if (app.environment == .testing) {
    databaseName = "vapor-test"
    databasePort = 5433
  } else {
    databaseName = "vapor_database"
    databasePort = 5432
  }
  
  app.databases.use(.postgres(
    hostname: Environment.get("DATABASE_HOST") ?? "localhost",
    port: databasePort,
//    port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? PostgresConfiguration.ianaPortNumber,
    username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
    password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
    database: Environment.get("DATABASE_NAME") ?? databaseName
  ), as: .psql)
  
  app.migrations.add(NeoEnablePostGISMigration())
  app.migrations.add(CreateRoadSegment())
  app.migrations.add(CreateNode())
  app.migrations.add(CreateNodeRoadSegmentPivot())
  app.migrations.add(CreateLocationTest())
  
  try app.autoRevert().wait()
  try app.autoMigrate().wait()
  // register routes
  try routes(app)
  
  
}


import Foundation
import FluentKit
import SQLKit
import PostgresNIO

public struct NeoEnablePostGISMigration: Migration {
    
    public init() {}
    
    enum EnablePostGISMigrationError: Error {
        case notSqlDatabase
    }

    public func prepare(on database: Database) -> EventLoopFuture<Void> {
        guard let db = database as? SQLDatabase else {
            return database.eventLoop.makeFailedFuture(EnablePostGISMigrationError.notSqlDatabase)
        }
        return db.raw("CREATE EXTENSION IF NOT EXISTS postgis").run()
    }

    public func revert(on database: Database) -> EventLoopFuture<Void> {
      database.eventLoop.future()
    }
}

public var FluentPostGISSrid: UInt = 4326
