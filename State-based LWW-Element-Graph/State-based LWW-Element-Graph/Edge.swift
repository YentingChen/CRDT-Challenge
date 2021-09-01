//
//  File.swift
//  State-based LWW-Element-Graph
//
//  Created by Yenting Chen on 2021/9/1.
//

struct Edge<T: Hashable>: Hashable {
    
    let from: T
    
    let to: T
}
