import Fluent
import Vapor
import Foundation

func routes(_ app: Application) throws {
  app.get { req in
    return "Accessy Server is online 🥳"
  }
  
  app.get("hello") { req -> String in
    return "Hello, you! Let's see…"
  }

  try app.group("api", configure: { builder in
    try builder.register(collection: NodesController())
    try builder.register(collection: SegmentsController())
  })
  
  try app.register(collection: PingPongController())
  try app.register(collection: TodoController())
  
  print("ALL ROUTES: \(app.routes.all)")
}



