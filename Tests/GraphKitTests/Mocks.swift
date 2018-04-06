//
//  Mocks.swift
//  GraphKitTests
//
//  Created by Marcus Rossel on 04.04.18.
//

// A vertex type used for testing.
enum TestVertex: VertexProtocol, Equatable, Hashable {
   case a, b, c, d, e, f
   
   static var all: Set<TestVertex> {
      return [.a, .b, .c, .d, .e, .f]
   }
}

// A simple edge type whose vertices are strings, used for testing.
struct TestEdge: EdgeProtocol, Hashable, Equatable, ExpressibleByArrayLiteral, CustomStringConvertible {

   var vertices: (TestVertex, TestVertex)
   
   init(vertices: (TestVertex, TestVertex)) {
      self.vertices = vertices
   }
   
   init(arrayLiteral elements: TestVertex...) {
      guard elements.count == 2 else {
         fatalError("A `TestEdge` must be initialized from exactly two vertices.")
      }
      
      self.init(vertices: (elements.first!, elements.last!))
   }
   
   var hashValue: Int {
      return vertices.0.hashValue ^ vertices.1.hashValue
   }
   
   static func ==(lhs: TestEdge, rhs: TestEdge) -> Bool {
      return lhs.vertices == rhs.vertices ||
             lhs.vertices == (rhs.vertices.1, rhs.vertices.0)
   }
   
   static var all: Set<TestEdge> {
      let allEdgesRedundantly = TestVertex.all.flatMap { start in
         TestVertex.all.map { end in
            return [start, end] as TestEdge
         }
      }
      
      return Set(allEdgesRedundantly)
   }
   
   var description: String {
      return "〈\(vertices.0)--\(vertices.1)〉"
   }
}

// A `Graph.Table` for a `Graph` that uses `TestEdge` for its edges.
typealias TestTable = Graph<TestEdge>.Table
