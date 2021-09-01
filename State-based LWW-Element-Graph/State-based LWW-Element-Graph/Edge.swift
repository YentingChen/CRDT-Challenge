//
//  File.swift
//  State-based LWW-Element-Graph
//
//  Created by Yenting Chen on 2021/9/1.
//

public struct Edge<T: Hashable> {
  public var source: Vertex<T>
  public var destination: Vertex<T>
  
}

extension Edge: Hashable {
  
  static public func ==(lhs: Edge<T>, rhs: Edge<T>) -> Bool {
    return lhs.source == rhs.source &&
      lhs.destination == rhs.destination
  }
}
