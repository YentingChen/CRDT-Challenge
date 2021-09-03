//
//  File.swift
//  State-based LWW-Element-Graph
//
//  Created by Yenting Chen on 2021/9/1.
//

//Edge contains its source and destination which are Vertex<T> type
struct Edge<T: Hashable> {
    
    var source: Vertex<T>
    
    var destination: Vertex<T>
  
}

extension Edge: Hashable {
    
    static func ==(lhs: Edge<T>, rhs: Edge<T>) -> Bool {
        
        return lhs.source == rhs.source && lhs.destination == rhs.destination
        
    }
    
}
