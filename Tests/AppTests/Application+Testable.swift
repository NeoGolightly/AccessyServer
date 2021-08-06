//
//  File.swift
//  File
//
//  Created by Michael Helmbrecht on 06.08.21.
//

import App
import XCTVapor

extension Application {
  static func testable() throws -> Application {
    let app = Application(.testing)
    try configure(app)
    
    try app.autoRevert().wait()
    try app.autoMigrate().wait()
    
    return app
  }
}

