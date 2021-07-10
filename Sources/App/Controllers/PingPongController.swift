//
//  File.swift
//  
//
//  Created by Michael Helmbrecht on 04.07.21.
//

import Vapor
import Fluent

struct PingPongController: RouteCollection {
  func boot(routes: RoutesBuilder) throws {
    routes.get("api", "ping", use: getPong)
  }
  
  func getPong(_ req: Request) -> EventLoopFuture<String> {
    req.eventLoop.future("pong")
  }
}
