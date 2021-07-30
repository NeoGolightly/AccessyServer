//
//  File.swift
//  File
//
//  Created by Michael Helmbrecht on 25.07.21.
//

import Vapor


///////////////////////////////////////////////////////////////
///
///
///   PROTOCOLS
///
///
///////////////////////////////////////////////////////////////


 protocol PathResponseRepresentable {
  var pathCoordinates: [Coordinate] { get }
}



 typealias InfrastructureResponseType = DateRepresentable & PathResponseRepresentable & IDRepresentable & Codable

///////////////////////////////////////////////////////////////
///
///
///   INFRASTRUCTURE TYPES
///
///
///////////////////////////////////////////////////////////////

 struct Infrastructure: Codable {
   let sidewalks: [Sidewalk]
   let trafficLights: [TrafficLight]
   let trafficIsland: [TrafficIsland]
   let zebraCrossing: [ZebraCrossing]
   let pedestrianCrossing: [PedestrianCrossing]
   let intersectionNodes: [IntersectionNode]
  ///
   init(sidewalks: [Sidewalk] = [],
              trafficLights: [TrafficLight] = [],
              trafficIsland: [TrafficIsland] = [],
              zebraCrossing: [ZebraCrossing] = [],
              pedestrianCrossing: [PedestrianCrossing] = [],
              intersectionNodes: [IntersectionNode] = []) {
    self.sidewalks = sidewalks
    self.trafficLights = trafficLights
    self.trafficIsland = trafficIsland
    self.zebraCrossing = zebraCrossing
    self.pedestrianCrossing = pedestrianCrossing
    self.intersectionNodes = intersectionNodes
  }
}

 struct Sidewalk: InfrastructureResponseType {
   let id: UUID?
   let pathCoordinates: [Coordinate]
   let createdAt: Date?
   let updatedAt: Date?
   let deletedAt: Date?
  ///
   init(id: UUID? = nil,
              pathCoordinates: [Coordinate],
              createdAt: Date? = nil,
              updatedAt: Date? = nil,
              deletedAt: Date? = nil) {
    self.id = id
    self.pathCoordinates = pathCoordinates
    self.createdAt = createdAt
    self.updatedAt = updatedAt
    self.deletedAt = deletedAt
  }
}

 struct TrafficLight: InfrastructureResponseType {
   let id: UUID?
   let pathCoordinates: [Coordinate]
   let createdAt: Date?
   let updatedAt: Date?
   let deletedAt: Date?
}

 struct TrafficIsland: InfrastructureResponseType {
   let id: UUID?
   let pathCoordinates: [Coordinate]
   let createdAt: Date?
   let updatedAt: Date?
   let deletedAt: Date?
}

 struct ZebraCrossing: InfrastructureResponseType {
   let id: UUID?
   let pathCoordinates: [Coordinate]
   let createdAt: Date?
   let updatedAt: Date?
   let deletedAt: Date?
}

 struct PedestrianCrossing: InfrastructureResponseType {
   let id: UUID?
   let pathCoordinates: [Coordinate]
   let createdAt: Date?
   let updatedAt: Date?
   let deletedAt: Date?
}

 struct IntersectionNode: DateRepresentable, IDRepresentable, AdjacentInfrastructuresRepresentable, Codable {
   let id: UUID?
   let coordinate: Coordinate
   let createdAt: Date?
   let updatedAt: Date?
   let deletedAt: Date?
  //
   let adjacentInfrastructures: [String]
  ///
   init(id: UUID? = nil,
              coordinate: Coordinate,
              createdAt: Date? = nil,
              updatedAt: Date? = nil,
              deletedAt: Date? = nil,
              adjacentInfrastructures: [String] = []) {
    self.id = id
    self.coordinate = coordinate
    self.createdAt = createdAt
    self.updatedAt = updatedAt
    self.deletedAt = deletedAt
    self.adjacentInfrastructures = adjacentInfrastructures
  }
}

///////////////////////////////////////////////////////////////
///
///
///   SUBTYPES
///
///
///////////////////////////////////////////////////////////////

 struct Coordinate: Codable {
   let latitude: Double
   let longitude: Double
   init(latitude: Double, longitude: Double) {
    self.latitude = latitude
    self.longitude = longitude
  }
}


struct CreateSidewalkResponse{
  let createdSidewalk: Sidewalk
  let createdIntersectionNodes: [IntersectionNode]
}
