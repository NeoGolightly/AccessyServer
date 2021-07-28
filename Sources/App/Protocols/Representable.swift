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

protocol DateRepresentable {
  var createdAt: Date? { get }
  var updatedAt: Date? { get }
  var deletedAt: Date? { get }
}

protocol PathRepresentable {
  var pathCoordinates: GeometricLineString2D { get }
}

protocol IDRepresentable {
  var id: UUID? { get }
}

protocol AdjacentInfrastructuresRepresentable {
  var adjacentInfrastructures: [String] { get }
}
