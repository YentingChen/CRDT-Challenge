//
//  State_based_LWW_Element_GraphTests.swift
//  State-based LWW-Element-GraphTests
//
//  Created by Yenting Chen on 2021/9/1.
//

import XCTest
@testable import State_based_LWW_Element_Graph

class State_based_LWW_Element_GraphTests: XCTestCase {
    
    var a: LWWGraph<Int>!
    var b: LWWGraph<Int>!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        a = .init()
        b = .init()
    }
    
    func testInitialCreation() {
        
        XCTAssertEqual(a.va.dataWithTime, [:])
        XCTAssertEqual(a.vr.dataWithTime, [:])
        XCTAssertEqual(a.ea.dataWithTime, [:])
        XCTAssertEqual(a.er.dataWithTime, [:])

    }
    
    ///Testing of adding vertice
    ///
    ///Action:
    ///     - Add vetex1, vertex2, and vertex3
    ///
    ///Check:
    ///     - Current vertices are vertex1, vertex2, and vertex3
    ///     - The count of vertexAddingSet is 3
    func testAddingVertex() {
        
        let vertex1 = Vertex(data: 1)
        let vertex2 = Vertex(data: 2)
        let vertex3 = Vertex(data: 3)
        
        a.addVertex(vertex: vertex1)
        a.addVertex(vertex: vertex2)
        a.addVertex(vertex: vertex3)
        
        let currentVertices = a.lookupCurrentVertices()
        XCTAssertEqual(currentVertices, [vertex1, vertex2, vertex3])
        
        let vertexAddedCout = a.va.dataWithTime.count
        XCTAssertEqual(vertexAddedCout, 3)
        
    }
    
    ///Testing of adding edges
    ///
    ///Pre:
    ///    - Vertex1 and vertex2 were added
    ///
    ///Action:
    ///     - Add directed edge(1,2)
    ///
    ///Check:
    ///     - Current edge is edge(1,2)
    ///     - The count of edgeAddingSet is 1
    func testAddingEdge() {
        
        let vertex1 = Vertex(data: 1)
        let vertex2 = Vertex(data: 2)
        let theEdge = Edge(source: Vertex(data: 1), destination: Vertex(data: 2))
        
        a.addVertex(vertex: vertex1)
        a.addVertex(vertex: vertex2)
        a.addEdge(source: vertex1, destination:vertex2, type: .directed)
        
        let currentEdges = a.lookupCurrentEdges()

        XCTAssertEqual(currentEdges, [theEdge])
        
        let edgeAddedCout = a.ea.dataWithTime.count
        XCTAssertEqual(edgeAddedCout, 1)
    }
    
    ///Testing of removing vetrice
    ///
    ///Pre:
    ///    - Vertex1, vertex2, and vertex3 were added
    ///
    ///Action:
    ///     - Remove vertex2
    ///
    ///Check:
    ///     - Current vertrice are Vertex1 and vertex3
    ///     - The count of vertexRemovingSet is 1
    func testRemovingVertex() {
        
        let vertex1 = Vertex(data: 1)
        let vertex2 = Vertex(data: 2)
        let vertex3 = Vertex(data: 3)
    
        a.addVertex(vertex: vertex1)
        a.addVertex(vertex: vertex2)
        a.addVertex(vertex: vertex3)
        a.removeVertex(vertex: vertex2)

        let currentVertices = a.lookupCurrentVertices()
        XCTAssertEqual(currentVertices, [vertex1, vertex3])
        
        let vertexRemovingCount = a.vr.dataWithTime.count
        XCTAssertEqual(vertexRemovingCount, 1)
    }
    
    ///Testing of removing edges
    ///
    ///Pre:
    ///    - Vertex1, vertex2, and vertex3 were added
    ///    - Directed edge(1, 2) and Undirected edge(1,3) were added
    ///
    ///Action:
    ///     - Remove Directed edge(1, 2)
    ///
    ///Check:
    ///     - Current Edges are  Undirected edge(1,3)
    ///     - The count of edgeAddedSet is 3
    ///     - The count of edgeRemovingSet is 1
    func testRemovingEdge() {
        
        let vertex1 = Vertex(data: 1)
        let vertex2 = Vertex(data: 2)
        let vertex3 = Vertex(data: 3)
        let edgeFrom1to3 = Edge(source: vertex1, destination: vertex3)
        let edgeFrom3to1 = Edge(source: vertex3, destination: vertex1)
    
        a.addVertex(vertex: vertex1)
        a.addVertex(vertex: vertex2)
        a.addVertex(vertex: vertex3)
        
        a.addEdge(source: vertex1, destination: vertex2, type: .directed)
        a.addEdge(source: vertex1, destination: vertex3, type: .undirected)
        a.removeEdge(vertex1: vertex1, vertex2: vertex2, edgeType: .directed)
        
        let currentEdges = a.lookupCurrentEdges()
        XCTAssertEqual(currentEdges, [edgeFrom1to3, edgeFrom3to1])
        
        let edgeAddingCout = a.ea.dataWithTime.count
        XCTAssertEqual(edgeAddingCout, 3)
        
        let edgeRemovingCout = a.er.dataWithTime.count
        XCTAssertEqual(edgeRemovingCout, 1)
    }
    
    //Testing of lookup vertex
    ///Pre:
    ///     - There are vertex1, vertex2, and vetex3
    ///Action:
    ///     - Add vetex1
    ///     - Add vertex3
    ///     - Remove vertex3
    ///
    ///Check:
    ///     - vertex1 exists
    ///     - vertex3 not exists
    func testLookingUpVertex() {
        
        let vertex1 = Vertex(data: 1)
        let vertex2 = Vertex(data: 2)
        let vertex3 = Vertex(data: 3)
        a.addVertex(vertex: vertex1)
        a.addVertex(vertex: vertex3)
        a.removeVertex(vertex: vertex3)
        
        let vertex1Existed = a.lookup(vertex: vertex1)
        let vertex2Existed = a.lookup(vertex: vertex2)
        XCTAssertEqual(vertex1Existed, true)
        XCTAssertEqual(vertex2Existed, false)
    }
    
    //Testing of lookup vertex
    ///Pre:
    ///     - There are vertex1, vertex2, and vetex3, edge(1,2), edge(2,1)
    ///Action:
    ///     - Add vetex1 and vertex2
    ///     - Add edge(1,2)
    ///
    ///Check:
    ///     - edge(1,2) exists
    ///     - edge(2,1) not exists
    func testLookUpEdge() {
        
        let vertex1 = Vertex(data: 1)
        let vertex2 = Vertex(data: 2)
        let edgeFrom1to2 = Edge(source: vertex1, destination: vertex2)
        let edgeFrom2to1 = Edge(source: vertex2, destination: vertex1)
        
        a.addVertex(vertex: vertex1)
        a.addVertex(vertex: vertex2)
       
        a.addEdge(edge: edgeFrom1to2)
        
        let edgeFrom1to2Existed = a.lookup(edge: edgeFrom1to2)
        let edgeFrom2to1Existed = a.lookup(edge: edgeFrom2to1)
        XCTAssertEqual(edgeFrom1to2Existed, true)
        XCTAssertEqual(edgeFrom2to1Existed, false)
    }
    
    //Testing of connected vertices
    ///Pre:
    ///     - vertex1, vertex2, vertex3 and vetex4 were added
    ///     - edge(1,2) and edge(1,3) were added
    ///Action:
    ///     - lookup vertex1's connected vertices
    ///
    ///Check:
    ///     - vertex1's connectd vertices are vertex2 and vertex3
    func testConnectedVertices() {
        
        let vertex1 = Vertex(data: 1)
        let vertex2 = Vertex(data: 2)
        let vertex3 = Vertex(data: 3)
        let vertex4 = Vertex(data: 4)
        let edgeFrom1to2 = Edge(source: vertex1, destination: vertex2)
        let edgeFrom1to3 = Edge(source: vertex1, destination: vertex3)
        
        a.addVertex(vertex: vertex1)
        a.addVertex(vertex: vertex2)
        a.addVertex(vertex: vertex3)
        a.addVertex(vertex: vertex4)
        a.addEdge(edge: edgeFrom1to2)
        a.addEdge(edge: edgeFrom1to3)
        
        let connectedVertices = Set(a.lookupConnectedVerties(vertex: vertex1))
        XCTAssertEqual(connectedVertices, Set([vertex2, vertex3]))
    }
    
    //Testing of connected edges
    ///Pre:
    ///     - vertex1, vertex2, vertex3 and vetex4 were added
    ///     - edge(1,2) and edge(1,3) were added
    ///     - edge(2,3) was added
    ///Action:
    ///     - lookup vertex1's connected edges
    ///
    ///Check:
    ///     - vertex1's connectd edges are edge(1,2) and edge(1,3)
    func testConnectedEdges() {
        
        let vertex1 = Vertex(data: 1)
        let vertex2 = Vertex(data: 2)
        let vertex3 = Vertex(data: 3)
        let vertex4 = Vertex(data: 4)
        let edgeFrom1to2 = Edge(source: vertex1, destination: vertex2)
        let edgeFrom1to3 = Edge(source: vertex1, destination: vertex3)
        let edgeFrom2to3 = Edge(source: vertex2, destination: vertex3)
        
        a.addVertex(vertex: vertex1)
        a.addVertex(vertex: vertex2)
        a.addVertex(vertex: vertex3)
        a.addVertex(vertex: vertex4)
        a.addEdge(edge: edgeFrom1to2)
        a.addEdge(edge: edgeFrom1to3)
        a.addEdge(edge: edgeFrom2to3)
        
        let connectedEdges = Set(a.lookupConnectedEdges(vertex: vertex1))
        
        XCTAssertEqual(connectedEdges, Set([edgeFrom1to2, edgeFrom1to3]))
    }
    
    ///Testing of Idempotency
    ///Merging the same values multiple times has no effect on the outcome
    ///
    ///Pre:
    ///  - Updated Graph a and Graph b
    ///
    ///Action:
    ///     - Graph c:  Graph a merge Graph b
    ///     - Graph d:  Graph c merge Graph b
    ///     - Graph e:  Graph c merged Graph a
    ///
    ///Check:
    ///     - Graph c is equal to Graph d
    ///     - Graph c is equal to Graph e
    func testIdempotency() {
        
        updateGraphAandB()
        
        var c = a.merge(anotherGraph: b)
        let d = c.merge(anotherGraph: b)
        let e = c.merge(anotherGraph: a)

        XCTAssertEqual(c.va, d.va)
        XCTAssertEqual(c.vr, d.vr)
        XCTAssertEqual(c.ea, d.ea)
        XCTAssertEqual(c.er, d.er)
        
        XCTAssertEqual(c.va, e.va)
        XCTAssertEqual(c.vr, e.vr)
        XCTAssertEqual(c.ea, e.ea)
        XCTAssertEqual(c.er, e.er)
        
    }

    ///Testing of Commutativity
    ///Merging order has no effect on the outcome.
    ///(A merged-with B) = (B merged-with A)
    ///It doesn’t matter whether you merge a with b, or b with a.
    ///
    ///Pre:
    ///     - Updated Graph a and Graph b
    ///
    ///Action:
    ///     - Graph c:  Graph a merge Graph b
    ///     - Graph d:  Graph b merge Graph a
    ///
    ///Check:
    ///     - Graph c is equal to Graph d
    ///     - Graph c is equal to Graph e
    func testCommutativity() {
        
        updateGraphAandB()

        let c = a.merge(anotherGraph: b)
        let d = b.merge(anotherGraph: a)

        XCTAssertEqual(d.va, c.va)
        XCTAssertEqual(d.vr, c.vr)
        XCTAssertEqual(d.ea, c.ea)
        XCTAssertEqual(d.er, c.er)

    }

    ///Testing of Associativity
    ///Rearranging the group of operations has no effect on the outcome.
    ///(A merged-with B) merged-with C = A merged-with (B merged-with C)
    ///
    ///Pre:
    ///     - Updated Graph a and Graph b
    ///     - Graph c
    ///
    ///Action:
    ///     - Graph e:  Graph a merge Graph b
    ///     - Graph f:  Graph e merge Graph c
    ///     - Graph g:  Graph a merge the result of the merge of Graph b with Graph c
    ///
    ///Check:
    ///     - Graph f is equal to Graph g
    func testAssociativity() {
        
        updateGraphAandB()
    
        var c: LWWGraph<Int> = .init()
        c.addVertex(vertex: Vertex(data: 10))
        c.addVertex(vertex: Vertex(data: 11))
        c.addVertex(vertex: Vertex(data: 12))
        c.removeVertex(vertex: Vertex(data: 10))
        
        b.addEdge(source: Vertex(data: 11), destination: Vertex(data: 12), type: .undirected)

        var e = a.merge(anotherGraph: b)
        let f = e.merge(anotherGraph: c)
        let g = a.merge(anotherGraph: b.merge(anotherGraph: c))
        
        XCTAssertEqual(f.va, g.va)
        XCTAssertEqual(f.vr, g.vr)
        XCTAssertEqual(f.ea, g.ea)
        XCTAssertEqual(f.er, g.er)
    }
    
    
    ///Update Graph a and Graph b
    ///
    ///- Graph a:
    ///     - added vertex1, vertex2, vertex3
    ///     - removed vertex1
    ///     - added Edge(2,3)
    ///
    /// - Graph b:
    ///     - added vertex1
    ///     - removed vertex1
    ///     - added vertex4, vertex5, vertex6
    ///     - removed vertex4
    ///     - added Edge(5,6)
    ///     - removed Edge(5,6)
    fileprivate func updateGraphAandB() {
        
        let vertex1 = Vertex(data: 1)
        let vertex2 = Vertex(data: 2)
        let vertex3 = Vertex(data: 3)
        let vertex4 = Vertex(data: 4)
        let vertex5 = Vertex(data: 5)
        let vertex6 = Vertex(data: 6)
        
        a.addVertex(vertex: vertex1)
        a.addVertex(vertex: vertex2)
        a.addVertex(vertex: vertex3)
        a.removeVertex(vertex: vertex1)

        b.addVertex(vertex: vertex1)
        b.removeVertex(vertex: vertex1)
        b.addVertex(vertex: vertex4)
        b.addVertex(vertex: vertex5)
        b.addVertex(vertex: vertex6)
        b.removeVertex(vertex: vertex4)
        
        a.addEdge(source: vertex2, destination: vertex3, type: .directed)
        b.addEdge(source: vertex5, destination: vertex6, type: .directed)
        b.removeEdge(vertex1: vertex5, vertex2: vertex6, edgeType: .directed)
        
    }

}
