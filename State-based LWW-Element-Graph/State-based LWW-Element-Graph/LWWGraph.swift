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
    
    // MARK: Lookup
    
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
    
    /// Returns the vertices `item` related to the query vertex.
    ///
    /// - Parameters:
    ///     - vertex: The item to look up.
    /// - Returns: The array `item` related to the query vertex.
    func lookupConnectedEdges(vertex: Vertex<T>) -> [Edge<T>] {
        
        var edges = [Edge<T>]()
        
        for i in ea.timestamps {
            
            if er.timestamps[i.key] == nil {
                
                if i.key.source == vertex {
                    
                    edges.append(i.key)

                }

                if i.key.destination == vertex {

                    edges.append(i.key)
                }

            }
            
        }
    
        return edges
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
    
    /// Returns the vertices `item` existing in the graph
    ///
    /// - Returns: The vertices `item` existing in the graph
    func lookupCurrentVertices() -> [Vertex<T>]  {
        
        var vertices = [Vertex<T> : Date]()
        
        for i in va.timestamps {
            
            if let previousRemoveTime = vr.timestamps[i.key] {
                
                if previousRemoveTime < i.value {
                    
                    vertices[i.key] = i.value
                    
                }
                
            } else {
                
                vertices[i.key] = i.value
                
            }
        }
        
        let sortedVertices = vertices.sorted {
            
            return $0.value < $1.value
            
        }.map({ $0.key })
        
        return sortedVertices
    }
    
    /// Returns the edges `item` existing in the graph
    ///
    /// - Returns: The edges `item` existing in the graph
    func lookupCurrentEdges() -> [Edge<T>]  {
        
        var edges = [Edge<T> : Date]()
        
        for i in ea.timestamps {
            
            if let previousRemoveTime = er.timestamps[i.key] {
                
                if previousRemoveTime < i.value {
                    
                    edges[i.key] = i.value
                    
                }
                
            } else {
                
                edges[i.key] = i.value
            }
        }
        
        let sortedEdges = edges.sorted {
            
            return $0.value < $1.value
            
        }.map({ $0.key })
        
        return sortedEdges

    }
    
    // MARK: Merge
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
    
    // MARK: Add
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
    
    /// Adds an Edge to this Graph.
    ///
    /// - Parameters:
    ///   - edge: The item to add to this graph
    mutating func addEdge(edge: Edge<T>) {
        
        /// - Precondition:
        ///     - The Source and Destination of the Edge exists
        ///     - All edges related to vertex not exists
        /// - Downtream:
        ///     - EA adds the Edge
        if lookup(vertex: edge.source) && lookup(vertex: edge.destination) {
            
            ea.add(edge)
            
        }
        
    }
    
    // MARK: Remove
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
        
        let edge = Edge(source: vertex1, destination: vertex2)
        
        removeEdge(edge: edge)
        
        if edgeType == .directed {
            
            let reversedEdge = Edge(source: vertex2, destination: vertex1)
            
            removeEdge(edge: reversedEdge)
            
        }
        
    }
    
    // Removes an edge from this Graph.
    ///
    /// - Parameters:
    ///   - edge: The item to remove from this graph.
    mutating func removeEdge(edge: Edge<T>) {
        
        /// - Precondition:
        ///     - The Edge exists
        ///
        /// - Downtream:
        ///     - Pre:  the edge is added
        ///     - ER adds the vertex
        if lookup(edge: edge) {
            
            if let eaDate = ea.lookup(edge), eaDate < Date() {
                
                er.add(edge)
                
            }
        }
        
    }

}
