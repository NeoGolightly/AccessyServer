//
//  File.swift
//  File
//
//  Created by Michael Helmbrecht on 17.07.21.
//

import Foundation
import FluentPostGIS
import Fluent



typealias InfrastructureType = DateRepresentable & PathRepresentable & IDRepresentable

public protocol DateRepresentable {
  var createdAt: Date? { get }
  var updatedAt: Date? { get }
  var deletedAt: Date? { get }
}

public protocol PathRepresentable {
  var pathCoordinates: GeometricLineString2D { get }
}

public protocol IDRepresentable {
  var id: UUID? { get }
}

public protocol AdjacentInfrastructuresRepresentable {
  var adjacentInfrastructures: [String] { get }
}
