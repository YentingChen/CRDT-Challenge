//
//  Vertex.swift
//  State-based LWW-Element-Graph
//
//  Created by Yenting Chen on 2021/9/1.
//

import Foundation

public struct Vertex<T: Hashable> {
  var data: T
}

extension Vertex: Hashable {
  
  static public func ==(lhs: Vertex, rhs: Vertex) -> Bool {
    return lhs.data == rhs.data
  }
}
