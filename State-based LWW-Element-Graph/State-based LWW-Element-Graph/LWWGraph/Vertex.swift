//
//  Vertex.swift
//  State-based LWW-Element-Graph
//
//  Created by Yenting Chen on 2021/9/1.
//

///A Vertex contains its  Generic type data.
struct Vertex<T: Hashable> {
    
    var data: T
    
}

extension Vertex: Hashable {
    
    static func == (lhs: Vertex, rhs: Vertex) -> Bool {
        
        return lhs.data == rhs.data
        
    }
    
}
