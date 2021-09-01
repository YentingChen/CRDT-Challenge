//
//  LWWGraph.swift
//  State-based LWW-Element-Graph
//
//  Created by Yenting Chen on 2021/9/1.
//

import Foundation

struct LWWGraph<T: Hashable> {
    
    /// - Instances:
    ///     - va: vertices added set
    ///     - vr: vertices removed set
    ///     - ea: edges removed set
    ///     - er: edges removed set
    var va = LWWGSet<Vertex<T>>()
    
    var vr = LWWGSet<Vertex<T>>()
    
    var ea = LWWGSet<Edge<T>>()
    
    var er = LWWGSet<Edge<T>>()
    
    /// Returns whether this vertex exists the graph.
    ///
    /// - Parameters:
    ///     - vetex: The item to look up.
    /// - Returns: Whether this vertex exists the graph.
    func lookup(vertex: Vertex<T>) -> Bool {
        
        if let vaDate = va.lookup(vertex), let vrDate = vr.lookup(vertex) {
            
            return vaDate > vrDate
            
        } else {
            
            return va.lookup(vertex) != nil &&  vr.lookup(vertex) == nil
            
        }
        
    }
    
    /// Returns whether this edge exists the graph.
    ///
    /// - Parameters:
    ///     - edge: The item to look up.
    /// - Returns: Whether this edge exists the graph.
    func lookup(edge: Edge<T>) -> Bool {
        
        if lookup(vertex: edge.source) && lookup(vertex: edge.destination) {

            return ea.lookup(edge) != nil && er.lookup(edge) == nil

        } else {

            return false
        }
        
    }
    
    func compare(anotherGraph: LWWGraph<T>) -> Bool {
        
        let sameVa = va.compare(anotherSet: anotherGraph.va)
        let sameVr = vr.compare(anotherSet: anotherGraph.vr)
        let sameEa = ea.compare(anotherSet: anotherGraph.ea)
        let sameEr = er.compare(anotherSet: anotherGraph.er)
        
        
        return (sameVa || sameVr) && (sameEa || sameEr)
        
    }
    
    /// Returns the vertices `item` related to the query vertex.
    ///
    /// - Parameters:
    ///     - vertex: The item to look up.
    /// - Returns: The array `item` related to the query vertex.
    func lookupConnectedVerties(vertex: Vertex<T>) -> [Vertex<T>] {
        
        var verties = [Vertex<T>]()
        
        for i in ea.timestamps {
            
            if er.timestamps[i.key] == nil {
                
                if i.key.source == vertex {
                    
                    verties.append(i.key.destination)

                }

                if i.key.destination == vertex {

                    verties.append(i.key.source)
                }

            }
            
        }
    
        return verties
    }
    
    /// Returns the edge `item` was added to this graph, if it was added.
    ///
    /// - Parameters:
    ///     - vertex1: The instance of the query item
    ///     - vertex2: The instance of the query item
    /// - Returns: The edge `item` was added or nil.
    func lookupEdge(vertex1: Vertex<T>, vertex2: Vertex<T>) -> Edge<T>? {
        
        for i in ea.timestamps {
            
            if er.timestamps[i.key] == nil {
                
                if (i.key.source == vertex1 && i.key.destination == vertex2) || (i.key.source == vertex2 && i.key.destination == vertex1) {

                    return i.key

                }
                
            }
            
        }
    
        return nil
    }
    
    /// Merges another graph into this graph
    ///
    /// - Parameter anotherGraph: The graph to merge into this graph.
    mutating func merge(anotherGraph: LWWGraph<T>) -> LWWGraph<T> {
        
        va = va.merge(anotherSet: anotherGraph.va)
        
        vr = vr.merge(anotherSet: anotherGraph.vr)
        
        ea = ea.merge(anotherSet: anotherGraph.ea)
        
        er = er.merge(anotherSet: anotherGraph.er)
        
        return LWWGraph(va: va, vr: vr, ea: ea, er: er)
        
    }
    
    /// Adds a Vertex to this Graph.
    ///
    /// - Parameters:
    ///   - vertex: The item to add to this graph
    mutating func addVertex(vertex: Vertex<T>) {
        
        va.add(vertex)
        
    }
    
    /// Adds an Edge to this Graph.
    ///
    /// - Parameters:
    ///   - source: The instance of adding edge.
    ///   - destination:The instance of adding edge.
    ///   - edgeType: the direction type of the Edge: directed, undirected
    mutating func addEdge(source: Vertex<T>, destination: Vertex<T>, type: EdgeType) {
        
        /// - Precondition:
        ///     - The Source and Destination of the Edge exists
        ///     - All edges related to vertex not exists
        /// - Downtream:
        ///     - EA adds the Edge
        ///     - If type is undirected, EA adds reversed Edge
        if lookup(vertex: source) && lookup(vertex: destination) {
            
            let edge = Edge(source: source, destination: destination)
            
            ea.add(edge)
            
            if type == .undirected {
                
                let reversedEdge = Edge(source: destination, destination: source)
                
                ea.add(reversedEdge)
                
            }
            
        }
    }
    
    /// Removes an vertex from this Graph.
    ///
    /// - Parameters:
    ///   - vertex: The item to remove from this graph.
    mutating func removeVertex(vertex: Vertex<T>) {
        
        /// - Precondition:
        ///     - Vertex exists
        ///     - All edges related to vertex not exists
        guard lookup(vertex: vertex) else { return }
        
        for i in ea.timestamps {
            
            if er.timestamps[i.key] == nil {
                
                if i.key.source == vertex || i.key.destination == vertex {
                    
                    return
                }
                
            }

        }
        
        /// - Downtream:
        ///     - Pre:  vertex is added
        ///     - VR add the vertex
        if let vaDate = va.lookup(vertex), vaDate < Date() {
            
            vr.add(vertex)
        }
        
    }
    
    // Removes an edge from this Graph.
    ///
    /// - Parameters:
    ///   - vertex1: the instance from the removing edge
    ///   - vertex2: the instance from the removing edge
    ///   - edgeType: the direction type of the Edge: directed, undirected
    mutating func removeEdge(vertex1: Vertex<T>, vertex2: Vertex<T>, edgeType: EdgeType) {
        
        /// - Precondition:
        ///     - There is an Edge which source is vertex1, and the destination is vertex2
        ///     - The Edge exists
        ///
        /// - Downtream:
        ///     - Pre:  the edge is added
        ///     - ER adds the vertex
        let edge = Edge(source: vertex1, destination: vertex2)

        if lookup(edge: edge) {
            
            if let eaDate = ea.lookup(edge), eaDate < Date() {
                
                er.add(edge)
                
            }
        }
        
        /// - Precondition:
        ///     - EdgeType is undirected
        ///     - There is an Edge which source is vertex2, and the destination is vertex1
        ///     - The Edge exists
        ///
        /// - Downtream:
        ///     - Pre:  the edge is added
        ///     - ER adds the vertex
        if edgeType == .undirected {
            
            let reversedEdge = Edge(source: vertex2, destination: vertex1)
            
            if lookup(edge: reversedEdge) {
                
                if let eaDate = ea.lookup(reversedEdge), eaDate < Date() {
                    
                    er.add(reversedEdge)
                    
                }
            }
        
        }
        
    }

}
