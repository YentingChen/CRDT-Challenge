//
//  LWWGraph.swift
//  State-based LWW-Element-Graph
//
//  Created by Yenting Chen on 2021/9/1.
//

import Foundation

struct LWWGraph<T: Hashable> {
    
    var va = LWWGSet<T>()
    
    var vr = LWWGSet<T>()
    
    var ea = LWWGSet<Edge<T>>()
    
    var er = LWWGSet<Edge<T>>()
    
    func lookup(vertex: T) -> Bool {
        
        return va.lookup(vertex) != nil && vr.lookup(vertex) == nil
        
    }
    
    func lookup(edge: Edge<T>) -> Bool {
        
        if lookup(vertex: edge.from) && lookup(vertex: edge.to) {

            return ea.lookup(edge) != nil && er.lookup(edge) == nil

        } else {

            return false
        }
        
    }
    
    func lookupConnectedVerties(vertex: T) -> [T] {
        
        var verties = [T]()
        
        for i in ea.timestamps {
            
            if er.timestamps[i.key] == nil {
                
                if i.key.from == vertex {

                    verties.append(i.key.to)

                }

                if i.key.to == vertex {

                    verties.append(i.key.from)
                }

            }
            
        }
    
        return verties
    }
    
    func lookupEdge(vertex1: T, vertex2: T) -> Edge<T>? {
        
        for i in ea.timestamps {
            
            if er.timestamps[i.key] == nil {
                
                if (i.key.from == vertex1 && i.key.to == vertex2) || (i.key.from == vertex2 && i.key.to == vertex1) {

                    return i.key

                }
                
            }
            
        }
    
        return nil
    }
    
    mutating func merge(anotherGraph: LWWGraph<T>) {
        
        va.merge(anotherSet: anotherGraph.va)
        
        vr.merge(anotherSet: anotherGraph.vr)
        
        ea.merge(anotherSet: anotherGraph.ea)
        
        er.merge(anotherSet: anotherGraph.er)
        
    }
    
    mutating func addVertex(vertex: T) {
        
        va.add(vertex)
        
    }
    
    mutating func addEdge(from: T, to: T, type: EdgeType) {
        
        if lookup(vertex: from) && lookup(vertex: from) {
            
            let edge = Edge(from: from, to: to)
            
            ea.add(edge)
            
            if type == .undirected {
                
                let reversedEdge = Edge(from: to, to: from)
                
                ea.add(reversedEdge)
                
            }
            
        }
    }
    
    mutating func removeVertex(vertex: T) {
        
        guard lookup(vertex: vertex) else { return }
        
        for i in ea.timestamps {
            
            if er.timestamps[i.key] == nil {
                
                if i.key.from == vertex || i.key.to == vertex {
                    
                    return
                }
                
            }

        }
        
        //remove vertex
        if let vaDate = va.lookup(vertex), vaDate < Date() {
            
            vr.add(vertex)
        }
        
    }
    
    mutating func removeEdge(vertex1: T, vertex2: T, edgeType: EdgeType) {
        
        let edge = Edge(from: vertex1, to: vertex2)
        
        if lookup(edge: edge) {
            
            if let eaDate = ea.lookup(edge), eaDate < Date() {
                
                er.add(edge)
                
            }
        }
        
        if edgeType == .undirected {
            
            let reversedEdge = Edge(from: vertex2, to: vertex1)
            
            if lookup(edge: reversedEdge) {
                
                if let eaDate = ea.lookup(reversedEdge), eaDate < Date() {
                    
                    er.add(reversedEdge)
                    
                }
            }
        
        }
        
    }

}
