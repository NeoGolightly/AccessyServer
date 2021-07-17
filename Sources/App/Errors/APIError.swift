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
}

extension APIError: AbortError {
  var reason: String{
    switch self {
    case .incorrectPointCount:
      return "Point count must be greater or equal two"
    case .incorrectNodesCount:
      return "Nodes count must be two"
    }
  }
  
    
  var status: HTTPStatus{
    return .badRequest
  }
}
