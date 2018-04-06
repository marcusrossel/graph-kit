//
//  Convenience Methods.swift
//  GraphKitTests
//
//  Created by Marcus Rossel on 05.04.18.
//

/*
 A set of convenience methods that can be used in the test.
 These methods do not rely on methods of the types being tested.
 They use knowledge of the internal type layout to circumnavigate use of those
 methods.
*/

extension Graph.Table: ExpressibleByArrayLiteral {
   
   /// Initializes a table from a given sequence of vertices.
   public init(arrayLiteral elements: Graph.Vertex...) {
      vertexTable = [:]
      edgeIDMap = [:]
      
      for element in elements { vertexTable[element] = [] }
   }
}

extension Graph.Table {
   
   /// Initializes a table from vertices and edges.
   ///
   /// If any edge does not match the vertices an error occurs.
   public init<Vs, Es>(vertices: Vs, edges: Es)
   where Vs: Sequence, Vs.Element == Graph.Vertex, Es: Sequence, Es.Element == Edge {
      // Checks for invalid edges.
      guard !edges.contains(where: { edge in
         !vertices.contains(edge.vertices.0) ||
         !vertices.contains(edge.vertices.1)
      })
      else {
         fatalError("Attempted to initialize `Graph.Table` with invalid edge.")
      }
      
      // Initializes the containers.
      vertexTable = [:]
      edgeIDMap = [:]
      
      // Sets the vertices.
      for vertex in vertices { vertexTable[vertex] = [] }
      
      // Sets the edges.
      for edge in edges {
         let identifier = Identifier()
         edgeIDMap[edge] = identifier
         
         // Forces unwrapping is used as the vertices are known to have a vertex
         // table entry.
         vertexTable[edge.vertices.0]!.insert(identifier)
         vertexTable[edge.vertices.1]!.insert(identifier)
      }
   }
}
