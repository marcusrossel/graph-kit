//
//  Graph - Conformances.swift
//  GraphKit
//
//  Created by Marcus Rossel on 20.08.17.
//  Copyright © 2017 Marcus Rossel. All rights reserved.
//

/*

// MARK: - Path: Sequence

extension Graph.Path: Sequence {
   
   public typealias Iterator = Array<Edge>.Iterator
   
   public func makeIterator() -> Iterator { return edges.makeIterator() }
}

// MARK: - Path: Equatable

extension Graph.Path: Equatable {
   
   public static func ==(left: Graph.Path, right: Graph.Path) -> Bool {
      return left.edges == right.edges
   }
}
*/

// MARK: - Table: Sequence

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
      guard let (vertex, indices) = vertexTable.first else { return nil }
      
      // Maps the vertex's associated indices to their edges.
      // Forced unwrapping is used as the index must have a corresponding edge.
      let edges = Set(indices.map { index in edgeIndexMap[index]! })
      
      return (vertex, edges)
   }
}

// MARK: - Table: Equatable

extension Graph.Table: Equatable where Graph.Vertex: Equatable {
   
   /// `Table`s are considered equal iff their `vertexTable`s and
   /// `edgeReferenceTable`s are equal.
   public static func ==(left: Graph.Table, right: Graph.Table) -> Bool {
      return left.vertexTable == right.vertexTable &&
             left.edgeIndexMap == right.edgeIndexMap
   }
}

// MARK: - Graph: Sequence

extension Graph: Sequence {
   
   /// The type of iterator used by `Graph` is its `Table`.
   public typealias Iterator = Table
   
   /// A graph`s iterator is its `Table`.
   public func makeIterator() -> Graph<Edge>.Table { return table }
}

// MARK: - Graph: Equatable

extension Graph: Equatable where Graph.Value: Equatable {
   
   /// `Graph`s are considered equal iff their `table`s are equal.
   public static func ==(left: Graph, right: Graph) -> Bool {
      return left.table == right.table
   }
}

// MARK: - Graph: ExpressibleByArrayLiteral

extension Graph: ExpressibleByArrayLiteral where Graph.Vertex: InitializableVertex {
   
   /// The type of element expected when initializing a `Graph` from an array
   /// literal.
   public typealias ArrayLiteralElement = Value
   
   /// When initializing a graph from an array literal, its elements are viewed
   /// as values. The `init(fromValues:)` intializer is called for those values.
   public init(arrayLiteral values: Value...) {
      self.init(fromValues: values)
   }
}
