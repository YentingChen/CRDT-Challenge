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
        
        XCTAssertEqual(a.va.timestamps, [:])
        XCTAssertEqual(a.vr.timestamps, [:])
        XCTAssertEqual(a.ea.timestamps, [:])
        XCTAssertEqual(a.er.timestamps, [:])

    }
    
    func testAdding() {

        //Test Vertices
        a.addVertex(vertex: Vertex(data: 1))
        a.addVertex(vertex: Vertex(data: 2))
        a.addVertex(vertex: Vertex(data: 3))

        let vaData = Set(a.va.timestamps.map({ $0.key.data }))

        XCTAssertEqual(vaData, [1,2,3])

        //Test Edges
        a.addEdge(source: Vertex(data: 1), destination: Vertex(data: 2), type: .directed)

        let eaData = Set(a.ea.timestamps.map({$0.key}))

        let theEdge = Edge(source: Vertex(data: 1), destination: Vertex(data: 2))

        XCTAssertEqual(eaData, [theEdge])
    }
    
    func testRemoving() {
        
        //Test Vertices
        a.addVertex(vertex: Vertex(data: 1))
        a.addVertex(vertex: Vertex(data: 2))
        a.addVertex(vertex: Vertex(data: 3))
        a.removeVertex(vertex: Vertex(data: 2))

        let vrData = Set(a.vr.timestamps.map({ $0.key.data}))
        let vaData = Set(a.va.timestamps.map({ $0.key.data}))

        XCTAssertEqual(vrData, [2])
        XCTAssertEqual(vaData, [1, 2, 3])
        
        //Test Edges
        a.addVertex(vertex: Vertex(data: 1))
        a.addVertex(vertex: Vertex(data: 2))
        a.addVertex(vertex: Vertex(data: 3))
        a.addEdge(source: Vertex(data: 1), destination: Vertex(data: 2), type: .directed)
        a.addEdge(source: Vertex(data: 1), destination: Vertex(data: 3), type: .directed)
        a.removeEdge(vertex1: Vertex(data: 1), vertex2: Vertex(data: 2), edgeType: .directed)
        XCTAssertEqual(a.ea.timestamps.count, 2)
        XCTAssertEqual(a.er.timestamps.count, 1)
    }
    
    func testIdempotency() {
        
        //Update Vertex
        a.addVertex(vertex: Vertex(data: 1))
        a.addVertex(vertex: Vertex(data: 2))
        a.addVertex(vertex: Vertex(data: 3))
        a.removeVertex(vertex: Vertex(data: 1))

        b.addVertex(vertex: Vertex(data: 1))
        b.removeVertex(vertex: Vertex(data: 1))
        b.addVertex(vertex: Vertex(data: 7))
        b.addVertex(vertex: Vertex(data: 8))
        b.addVertex(vertex: Vertex(data: 9))
        b.removeVertex(vertex: Vertex(data: 8))
        
        //Update Edge
        a.addEdge(source: Vertex(data: 2), destination: Vertex(data: 3), type: .directed)
        
        b.addEdge(source: Vertex(data: 7), destination: Vertex(data: 9), type: .directed)
        b.removeEdge(vertex1: Vertex(data: 7), vertex2: Vertex(data: 9), edgeType: .directed)
        
        var c = a.merge(anotherGraph: b)
        let d = c.merge(anotherGraph: b)
        let e = c.merge(anotherGraph: a)

        XCTAssertEqual(c.va, d.va)
        XCTAssertEqual(c.vr, d.vr)
        XCTAssertEqual(c.va, e.va)
        XCTAssertEqual(c.vr, e.vr)
        
        XCTAssertEqual(c.ea, d.ea)
        XCTAssertEqual(c.er, d.er)
        XCTAssertEqual(c.ea, e.ea)
        XCTAssertEqual(c.er, e.er)
    }

    func testCommutativity() {
        a.addVertex(vertex: Vertex(data: 1))
        a.addVertex(vertex: Vertex(data: 2))
        a.addVertex(vertex: Vertex(data: 3))
        a.removeVertex(vertex: Vertex(data: 2))

        b.addVertex(vertex: Vertex(data: 10))
        b.removeVertex(vertex: Vertex(data: 10))
        b.addVertex(vertex: Vertex(data: 7))
        b.addVertex(vertex: Vertex(data: 8))
        b.addVertex(vertex: Vertex(data: 9))
        b.removeVertex(vertex: Vertex(data: 8))
        
        //Update Edge
        a.addEdge(source: Vertex(data: 1), destination: Vertex(data: 3), type: .directed)
        
        b.addEdge(source: Vertex(data: 7), destination: Vertex(data: 9), type: .directed)
        b.removeEdge(vertex1: Vertex(data: 7), vertex2: Vertex(data: 9), edgeType: .directed)

        let c = a.merge(anotherGraph: b)
        let d = b.merge(anotherGraph: a)

        let vaData = Set(d.va.timestamps.map({ $0.key.data})).sorted()
        let eaDataCount = d.ea.timestamps.map({ $0.key.source.data}).sorted()

        XCTAssertEqual(vaData, [1,2,3,7,8,9,10])
        XCTAssertEqual(eaDataCount, [1, 7])

        XCTAssertEqual(d.va, c.va)
        XCTAssertEqual(d.vr, c.vr)

    }

    func testAssociativity() {
        
        //Update Vertex
        a.addVertex(vertex: Vertex(data: 1))
        a.addVertex(vertex: Vertex(data: 2))
        a.removeVertex(vertex: Vertex(data: 2))
        a.addVertex(vertex: Vertex(data: 3))

        b.addVertex(vertex: Vertex(data: 5))
        b.addVertex(vertex: Vertex(data: 6))
        b.addVertex(vertex: Vertex(data: 7))
        
        //Update Edge
        a.addEdge(source: Vertex(data: 1), destination: Vertex(data: 3), type: .directed)
        
        b.addEdge(source: Vertex(data: 5), destination: Vertex(data: 6), type: .directed)
        b.removeEdge(vertex1: Vertex(data: 5), vertex2: Vertex(data: 6), edgeType: .directed)

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

}
