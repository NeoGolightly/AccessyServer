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
    try builder.register(collection: IntersectionNodesController())
    try builder.register(collection: SidewalksController())
    try builder.register(collection: InfrastructureController())
    try builder.register(collection: PingPongController())
  })
  
  
  
  
  print("ALL ROUTES: \(app.routes.all)")
}



