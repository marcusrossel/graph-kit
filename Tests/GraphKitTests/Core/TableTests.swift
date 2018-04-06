//
//  TableTests.swift
//  GraphKitTests
//
//  Created by Marcus Rossel on 04.04.18.
//

import XCTest

class TableTests: XCTestCase {

   // MARK: - Tests
   
   func testIdentifierEquality() {
      let id0 = TestTable.Identifier()
      let id1 = TestTable.Identifier()
      
      XCTAssertEqual(id0, id0)
      XCTAssertNotEqual(id0, id1)
   }
   
   func testInitialization() {
      let vertices0: Set<TestVertex> = []
      let vertices1 = TestVertex.all
      
      let table0 = TestTable(vertices: vertices0)
      let table1 = TestTable(vertices: vertices1)
      
      XCTAssertTrue(table0.edgeIDMap.isEmpty)
      XCTAssertTrue(table0.vertexTable.isEmpty)
      XCTAssertTrue(table1.edgeIDMap.isEmpty)
      XCTAssertEqual(Set(table1.vertexTable.keys), vertices1)
   }
   
   func testDegreeOfSafeVertex() {
      let edges: Set<TestEdge> = [[.a, .a], [.a, .b], [.a, .c], [.b, .e], [.c, .f]]
      let table = TestTable(vertices: TestVertex.all, edges: edges)

      XCTAssertEqual(table.degree(ofSafe: .a), 3)
   }

   func testEdgesIncidentToSafeVertex() {
      let edges: Set<TestEdge> = [[.a, .a], [.a, .b], [.a, .c], [.b, .e], [.c, .f]]
      let table = TestTable(vertices: TestVertex.all, edges: edges)
      
      let edgesIncidentToA = Set(table.edges(incidentToSafe: .a))
      
      let desiredResult: Set<TestEdge> = [[.a, .a], [.a, .b], [.a, .c]]
      XCTAssertEqual(edgesIncidentToA, desiredResult)
   }
   
   func testAdjacentVerticesForSafeVertex() {
      let edges: Set<TestEdge> = [[.a, .a], [.a, .b], [.a, .c], [.b, .e], [.c, .f]]
      let table = TestTable(vertices: TestVertex.all, edges: edges)
      
      let verticesAdjacentToA = Set(table.adjacentVertices(forSafe: .a))
      
      let desiredResult: Set<TestVertex> = [.a, .b, .c]
      XCTAssertEqual(verticesAdjacentToA, desiredResult)
   }
   
   func testSafeVertexInsertion() {
      var table: TestTable = [.a, .b, .c]
      
      table.insert(safeVertex: .d)
      
      let desiredResult: TestTable = [.a, .b, .c, .d]
      XCTAssertEqual(table, desiredResult)
   }
   
   func testSafeEdgeInsertion() {
      let vertices = TestVertex.all
      let edge: TestEdge = [.a, .b]
      var table = TestTable(vertices: vertices)
      
      table.insert(safeEdge: edge)
      
      let desiredResult = TestTable(vertices: vertices, edges: [edge])
      XCTAssertEqual(table, desiredResult)
   }
   
   func testSafeVertexRemoval()  {
      let vertices = TestVertex.all
      let edges = TestEdge.all
      var table = TestTable(vertices: vertices, edges: edges)
      
      let removee: TestVertex = .a
      table.remove(safeVertex: removee)
      
      let desiredRemainingEdges = edges.filter { !$0.isIncident(to: removee) }
      let desiredRemainingVertices = vertices.filter { $0 != removee }
      let desiredResult = TestTable(
         vertices: desiredRemainingVertices,
         edges: desiredRemainingEdges
      )
      
      XCTAssertEqual(table, desiredResult)
   }
   
   func testSafeEdgeRemoval() {
      let vertices = TestVertex.all
      let edges = TestEdge.all
      var table = TestTable(vertices: vertices, edges: edges)
      
      let removee: TestEdge = [.a, .b]
      table.remove(safeEdge: removee)
      
      let desiredRemainingEdges = edges.filter { $0 != removee }
      let desiredResult = TestTable(
         vertices: vertices,
         edges: desiredRemainingEdges
      )
      
      XCTAssertEqual(table, desiredResult)
   }
   
   func testRemovingAll() {
      let vertices = TestVertex.all
      let edges = TestEdge.all
      var table = TestTable(vertices: vertices, edges: edges)
      
      table.removeAll()
      
      let desiredResult: TestTable = []
      XCTAssertEqual(table, desiredResult)
   }

   func testEquality() {
      let someVertices: Set<TestVertex> = [.a, .b, .c]
      let someEdges: Set<TestEdge> = [[.a, .b], [.a, .c], [.b, .c]]

      let table0: TestTable = []
      let table1A = TestTable(vertices: someVertices, edges: someEdges)
      let table1B = TestTable(vertices: someVertices, edges: someEdges)
      let table2 = TestTable(vertices: TestVertex.all, edges: someEdges)
      let table3 = TestTable(vertices: TestVertex.all, edges: TestEdge.all)
      
      XCTAssertEqual(table0, table0)
      XCTAssertEqual(table1A, table1B)
      XCTAssertNotEqual(table0, table1A)
      XCTAssertNotEqual(table1A, table2)
      XCTAssertNotEqual(table2, table3)
   }
   
   func testSequenceConformance() {
      let table = TestTable(vertices: TestVertex.all, edges: TestEdge.all)
      
      let allElements = table.map { $0 }
      
      for (vertex, identifiers) in table.vertexTable {
         let edges = identifiers.map { id in table.edgeIDMap[id]! }
         let element = (vertex, Set(edges))
         
         XCTAssertTrue(allElements.contains { $0 == element })
      }
   }
   
   // MARK: - Package Support
   
   static var allTests = [
      ("testIdentifierEquality", testIdentifierEquality),
      ("testDegreeOfSafeVertex", testDegreeOfSafeVertex),
      ("testEdgesIncidentToSafeVertex", testEdgesIncidentToSafeVertex),
      ("testAdjacentVerticesForSafeVertex", testAdjacentVerticesForSafeVertex),
      ("testEmptyInitialization", testInitialization),
      ("testSafeVertexInsertion", testSafeVertexInsertion),
      ("testSafeEdgeInsertion", testSafeEdgeInsertion),
      ("testSafeVertexRemoval", testSafeVertexRemoval),
      ("testSafeEdgeRemoval", testSafeEdgeRemoval),
      ("testRemovingAll", testRemovingAll),
      ("testEquality", testEquality),
      ("testSequenceConformance", testSequenceConformance),
   ]
}
