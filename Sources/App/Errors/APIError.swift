//
//  File.swift
//  
//
//  Created by Michael Helmbrecht on 10.07.21.
//

import Vapor

enum APIError {
  case incorrectPointCount
  case incorrectNodesCount
  case firstAndLastPointCanNotBeEqual
  case sidewalkAlreadyExists
  case intersectionNodeAlreadyExists
}

extension APIError: AbortError {
  var reason: String{
    switch self {
    case .incorrectPointCount:
      return "Point count must be greater or equal two"
    case .incorrectNodesCount:
      return "Nodes count must be two"
    case .firstAndLastPointCanNotBeEqual:
      return "First and last point can not be equal"
    case .sidewalkAlreadyExists:
      return "Sidewalk already exists"
    case .intersectionNodeAlreadyExists:
      return "Intersection node already exists"
    }
  }
  
    
  var status: HTTPStatus{
    return .badRequest
  }
}
