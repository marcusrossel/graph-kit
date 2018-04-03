//
//  Table.swift
//  GraphKit
//
//  Created by Marcus Rossel on 17.02.18.
//  Copyright © 2018 Marcus Rossel. All rights reserved.
//

import BiMap

extension Graph {
   
   // This type uses the concept of "safe" vertices and edges.
   // A vertex or edge can be "safe to insert" or "safe to remove".
   //
   // (1) Vertices:
   //   * A vertex is safe to insert iff:
   //     - it is not part of the table
   //   * A vertex is safe to remove iff:
   //     - it is part of the table
   //
   // (2) Edges:
   //   * An edge is safe to insert iff:
   //     - both of its vertices are part of the table
   //     - the edge is not part of the table
   //   * An edge is safe to remove iff:
   //     - the edge is part of the table
   //
   /// The type used by `Graph` to manage storage of its edges and vertices.
   public struct Table: Equatable {
      
      // MARK: - Type Declarations
      
      /// An identifier type used to uniquely identify edges in a graph table.
      public final class Identifier: IdentitySemantic, Hashable {
         
         /// Creates a new identifier.
         internal init() { }
      }
      
      // MARK: - Properties
      
      /// A bimap containing all of the edges in the table.
      ///
      /// Each edge is stored with a fixed identifier. This identifier can be
      /// used to uniquely reference an edge across its lifetime in the table.
      internal var edgeIDMap: BiMap<Edge, Identifier>
      
      /// All of the vertices in the table with a list of identifiers
      /// referencing associated edges.
      internal var vertexTable: [Vertex: Set<Identifier>]
      
      // MARK: - Methods
      
      /// Returns the number of edges connected to a given safe vertex.
      ///
      /// Complexity: O(1)
      internal func degree(ofSafe safeVertex: Vertex) -> Int {
         // Forced unwrapping is used as the vertex is assured to be safe.
         return vertexTable[safeVertex]!.count
      }
      
      /// Returns the edges for a given safe vertex.
      ///
      /// Complexity: O(vertex.degree)
      internal func edges(forSafe safeVertex: Vertex) -> [Edge] {
         // Forced unwrapping is used as the vertex is assured to be safe.
         return vertexTable[safeVertex]!.map { identifier in
            // Forced unwrapping is used as the identifier must have a
            // corresponding edge.
            edgeIDMap[identifier]!
         }
      }
      
      /// Returns the vertices adjacent to a given safe vertex.
      ///
      /// Complexity: O(vertex.degree)
      internal func adjacentVertices(forSafe safeVertex: Vertex) -> [Vertex] {
         // Maps all of the given vertex' edges to the vertices that are not the
         // given one.
         return edges(forSafe: safeVertex).map { edge in
            (edge.vertices.0 != safeVertex) ? edge.vertices.0 : edge.vertices.1
         }
      }
      
      /// Inserts a safe vertex into the table.
      ///
      /// Complexity: O(1)
      internal mutating func insert(safeVertex: Vertex) {
         vertexTable[safeVertex] = []
      }
      
      /// Inserts a safe edge into the table.
      ///
      /// Complexity: O(1)
      internal mutating func insert(safeEdge: Edge) {
         // Generates a new identifier.
         let newID = Identifier()
         
         // Inserts the edge into the edge-ID map using the new identifier.
         edgeIDMap[newID] = safeEdge
         
         // Adds the identifier to the vertex-table.
         // Forced unwrapping is used as the edge is assured to be safe.
         vertexTable[safeEdge.vertices.0]!.insert(newID)
         vertexTable[safeEdge.vertices.1]!.insert(newID)
      }
      
      /// Removes a safe vertex from the table.
      /// This also removes all of the edges incident to the vertex.
      ///
      /// Returns the number of edges that were removed in the process.
      ///
      /// Complexity: O((vertex.degree)²)
      @discardableResult
      internal mutating func remove(safeVertex: Vertex) -> Int {
         // Gets the identifiers of the edges incident to the vertex.
         // Forced unwrapping is used as the vertex is assured to be safe.
         let affectedIDs = vertexTable[safeVertex]!
         
         // A record of all of the vertices whose vertex-table entry has already
         // been updated.
         var processedVertices = Set<Vertex>()
         
         for affectedID in affectedIDs {
            // Gets the edge that will be removed.
            // Forced unwrapping is used as the identifier is known to be valid.
            let affectedEdge = edgeIDMap[affectedID]!
            
            // Gets the vertex incident to the affected edge that is not the
            // given safe vertex.
            let affectedVertex = { vertices -> Vertex in
               return (vertices.0 == safeVertex) ? vertices.1 : vertices.0
            }(affectedEdge.vertices)
            
            // Only processes the affected vertex if it hasn't been processed
            // yet.
            if !processedVertices.contains(affectedVertex) {
               // If the call to `.subtract` wasn't O(vertex.degree) everytime,
               // but rather O(actuallySubtractedElements.count), the whole
               // method's runtime should be reducable to O(vertex.degree).
               
               // Removes the identifiers of edges that will be removed from the
               // affected vertex' vertex-table entry.
               // Forced unwrapping is used as the vertex is known to be valid.
               vertexTable[affectedVertex]!.subtract(affectedIDs)
               
               // Declares the vertex as processed.
               processedVertices.insert(affectedVertex)
            }
            
            // Removes the edge corresponding to the affected identifier.
            edgeIDMap[affectedID] = nil
         }
         
         // Removes the vertex.
         vertexTable[safeVertex] = nil
         
         // Returns the number of edges removed.
         return affectedIDs.count
      }
      
      /// Removes a safe edge from the table.
      ///
      /// Complexity: O(1)
      internal mutating func remove(safeEdge: Edge) {
         // Gets the identifier of the edge.
         // Forced unwrapping is used as the edge is assured to be safe.
         let edgeID = edgeIDMap[safeEdge]!
         
         // Removes the identifier from the vertices' vertex-table entries.
         // Forced unwrapping is used as the edge is assured to be safe.
         vertexTable[safeEdge.vertices.0]!.remove(edgeID)
         vertexTable[safeEdge.vertices.1]!.remove(edgeID)
         
         // Removes the edge from the edge-ID map.
         edgeIDMap[edgeID] = nil
      }
      
      //#warning("Determine complexity.")
      /// Removes all vertices and edges in the table.
      internal mutating func removeAll(keepingCapacity: Bool = false) {
         vertexTable.removeAll(keepingCapacity: keepingCapacity)
         edgeIDMap.removeAll(keepingCapacity: keepingCapacity)
      }
      
      // MARK: - Initializers

      /// Creates an instance containing given vertices.
      ///
      /// Complexity: O(vertices.count)
      internal init<S>(vertices: S)
      where S: Sequence, S.Element == Vertex {
         // Sets everything as empty.
         vertexTable = [:]
         edgeIDMap = [:]
         
         // Populates the vertex-storage if necessary.
         for vertex in vertices { vertexTable[vertex] = [] }
      }
   }
}

// MARK: - Conformances

extension Graph.Table: IteratorProtocol, Sequence {
   
   /// The type of element when iterating over a graph-table.
   public typealias Element = (Graph.Vertex, Set<Edge>)
   
   //#warning("This is not O(1)!")
   /// The next element in the sequence of a graph-table's `Element`s.
   ///
   /// Complexity: O(returnValue.1.count)
   public mutating func next() -> (Graph.Vertex, Set<Edge>)? {
      // Gets the vertex-table entry for some vertex. If there are none, `nil`
      // is returned.
      guard let (vertex, identifiers) = vertexTable.first else { return nil }
      
      // Maps the vertex's associated identifiers to their edges.
      // Forced unwrapping is used as the identifier must have a corresponding
      // edge.
      let edges = Set(identifiers.map { id in edgeIDMap[id]! })
      
      return (vertex, edges)
   }
}

extension Graph.Table: Collection {
   
   /// The type used by a `Graph.Table` to index it as a collection.
   public typealias Index = Dictionary<Graph.Vertex, Set<Identifier>>.Index
   
   /// The table's start index.
   ///
   /// Complexity: O(1)
   public var startIndex: Index { return vertexTable.startIndex }
   
   /// The table's end index.
   ///
   /// Complexity: O(1)
   public var endIndex: Index { return vertexTable.endIndex }
   
   /// Returns the element at a given index.
   ///
   /// Complexity: O(1)
   public subscript(position: Index) -> Element {
      return vertexTable[position]
   }
   
   /// Returns the index after a given index.
   ///
   /// Complexity: O(1)
   public func index(after index: Index) -> Index {
      return vertexTable.index(after: index)
   }
}
