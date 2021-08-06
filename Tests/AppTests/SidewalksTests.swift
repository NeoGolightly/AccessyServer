//
//  SidewalksTests.swift
//  SidewalksTests
//
//  Created by Michael Helmbrecht on 06.08.21.
//

@testable import App
import XCTVapor
import Quick
import Nimble
import Network

class SidewalksSpec: QuickSpec {

  var app: Application!

  override func spec() {
    
    
    
    let sidewalksURI = "api/sidewalks"
    let coordinate1 = Coordinate(latitude: 51.90797749529181, longitude: 10.427344884597142)
    let coordinate2 = Coordinate(latitude: 51.90755454203252, longitude: 10.427626795980052)
    //Create testable application
    
    
    
    describe("a sidewalk") {
      beforeEach {
        print("beforeSuite")
        do{
          self.app = try Application.testable()
        } catch {
          print(error)
        }
      }
      
      afterEach {
        self.app.shutdown()
      }
      it("can be saved and returns the new sidewalk and newly created intersection nodes") {
        let sidewalk = Sidewalk(pathCoordinates: [coordinate1, coordinate2])
        try self.app.test(.POST, sidewalksURI) { req in
          try req.content.encode(sidewalk)
        } afterResponse: { response in
          expect(response.status).to(equal(.ok))
        }


      }
    }
  }
}
